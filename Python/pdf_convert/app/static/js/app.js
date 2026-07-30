const form = document.querySelector("#compress-form");
const input = document.querySelector("#pdf-file");
const dropZone = document.querySelector("#drop-zone");
const fileSummary = document.querySelector("#file-summary");
const fileName = document.querySelector("#file-name");
const fileSize = document.querySelector("#file-size");
const compressButton = document.querySelector("#compress-button");
const statusPanel = document.querySelector("#status-panel");
const progressArea = document.querySelector("#progress-area");
const progressBar = document.querySelector("#progress-bar");
const statusText = document.querySelector("#status-text");
const resultArea = document.querySelector("#result-area");
const goalBadge = document.querySelector("#goal-badge");
const originalSize = document.querySelector("#original-size");
const compressedSize = document.querySelector("#compressed-size");
const reduction = document.querySelector("#reduction");
const resultMessage = document.querySelector("#result-message");
const downloadLink = document.querySelector("#download-link");
const resetButton = document.querySelector("#reset-button");
const errorMessage = document.querySelector("#error-message");

let selectedFile = null;
let progressTimer = null;

const states = [
  "Validando PDF...",
  "Probando compresion moderada...",
  "Ajustando resolucion de imagenes...",
  "Optimizando fuentes y metadatos...",
  "Verificando el PDF resultante..."
];

function formatBytes(bytes) {
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(2)} MB`;
}

function showError(message) {
  errorMessage.textContent = message;
  errorMessage.hidden = false;
}

function clearError() {
  errorMessage.hidden = true;
  errorMessage.textContent = "";
}

function setFile(file) {
  clearError();
  if (!file) return;
  if (file.type !== "application/pdf" || !file.name.toLowerCase().endsWith(".pdf")) {
    selectedFile = null;
    input.value = "";
    fileSummary.hidden = true;
    compressButton.disabled = true;
    showError("Selecciona un archivo PDF valido.");
    return;
  }
  selectedFile = file;
  fileName.textContent = file.name;
  fileSize.textContent = formatBytes(file.size);
  fileSummary.hidden = false;
  compressButton.disabled = false;
}

function startProgress() {
  let progress = 8;
  let index = 0;
  statusPanel.hidden = false;
  progressArea.hidden = false;
  resultArea.hidden = true;
  progressBar.style.width = `${progress}%`;
  statusText.textContent = states[index];
  progressTimer = window.setInterval(() => {
    progress = Math.min(progress + Math.random() * 12, 88);
    index = Math.min(index + 1, states.length - 1);
    progressBar.style.width = `${progress}%`;
    statusText.textContent = states[index];
  }, 850);
}

function stopProgress() {
  window.clearInterval(progressTimer);
  progressBar.style.width = "100%";
}

function showResult(data) {
  progressArea.hidden = true;
  resultArea.hidden = false;
  goalBadge.textContent = data.target_reached ? "Objetivo alcanzado" : "No fue posible alcanzar los 700 KB";
  goalBadge.className = `goal-badge ${data.target_reached ? "success" : "warning"}`;
  originalSize.textContent = formatBytes(data.original_size);
  compressedSize.textContent = formatBytes(data.compressed_size);
  reduction.textContent = `${data.reduction_percentage}%`;
  resultMessage.textContent = data.message;
  downloadLink.href = `/api/download/${data.download_id}`;
  downloadLink.setAttribute("download", data.output_filename);
}

input.addEventListener("change", () => setFile(input.files[0]));

dropZone.addEventListener("dragover", (event) => {
  event.preventDefault();
  dropZone.classList.add("is-dragging");
});

dropZone.addEventListener("dragleave", () => {
  dropZone.classList.remove("is-dragging");
});

dropZone.addEventListener("drop", (event) => {
  event.preventDefault();
  dropZone.classList.remove("is-dragging");
  const file = event.dataTransfer.files[0];
  input.files = event.dataTransfer.files;
  setFile(file);
});

form.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (!selectedFile) return;
  clearError();
  compressButton.disabled = true;
  startProgress();

  const body = new FormData();
  body.append("file", selectedFile);

  try {
    const response = await fetch("/api/compress", { method: "POST", body });
    const data = await response.json();
    if (!response.ok) {
      throw new Error(data.detail || "No se pudo comprimir el PDF.");
    }
    stopProgress();
    showResult(data);
  } catch (error) {
    window.clearInterval(progressTimer);
    statusPanel.hidden = true;
    showError(error.message);
    compressButton.disabled = false;
  }
});

resetButton.addEventListener("click", () => {
  selectedFile = null;
  input.value = "";
  fileSummary.hidden = true;
  statusPanel.hidden = true;
  resultArea.hidden = true;
  compressButton.disabled = true;
  clearError();
});
