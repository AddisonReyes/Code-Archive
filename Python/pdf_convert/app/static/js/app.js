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
const languageButtons = document.querySelectorAll("[data-language]");

const translations = {
  en: {
    "meta.title": "PDF Compressor",
    "hero.eyebrow": "Secure temporary processing",
    "hero.title": "PDF Compressor",
    "hero.description": "Upload a PDF and the app will try to reduce it below 700 KB without deleting pages or corrupting the document.",
    "upload.title": "Choose your file",
    "upload.limit": "Maximum upload size",
    "upload.dropTitle": "Drop your PDF here",
    "upload.dropSubtitle": "or click to choose a file",
    "actions.compress": "Compress PDF",
    "actions.download": "Download",
    "actions.reset": "Process another file",
    "progress.prepare": "Preparing compression...",
    "metrics.original": "Original size",
    "metrics.compressed": "Final size",
    "metrics.reduction": "Reduction",
    "footer.madeBy": "Made by",
    "validation.invalidPdf": "Please choose a valid PDF file.",
    "errors.generic": "The PDF could not be compressed.",
    "goal.success": "Target reached",
    "goal.warning": "Could not reach 700 KB",
    "result.success": "Target reached.",
    "result.warning": "It was not possible to reach 700 KB without degrading readability further.",
    "states.0": "Validating PDF...",
    "states.1": "Trying balanced compression...",
    "states.2": "Adjusting image resolution...",
    "states.3": "Optimizing fonts and metadata...",
    "states.4": "Verifying the resulting PDF..."
  },
  es: {
    "meta.title": "Compresor de PDF",
    "hero.eyebrow": "Procesamiento seguro y temporal",
    "hero.title": "Compresor de PDF",
    "hero.description": "Sube un PDF y la aplicacion intentara reducirlo por debajo de 700 KB sin eliminar paginas ni romper el documento.",
    "upload.title": "Selecciona el archivo",
    "upload.limit": "Tamano maximo permitido",
    "upload.dropTitle": "Arrastra tu PDF aqui",
    "upload.dropSubtitle": "o haz clic para elegirlo",
    "actions.compress": "Comprimir PDF",
    "actions.download": "Descargar",
    "actions.reset": "Procesar otro archivo",
    "progress.prepare": "Preparando compresion...",
    "metrics.original": "Tamano original",
    "metrics.compressed": "Tamano final",
    "metrics.reduction": "Reduccion",
    "footer.madeBy": "Hecho por",
    "validation.invalidPdf": "Selecciona un archivo PDF valido.",
    "errors.generic": "No se pudo comprimir el PDF.",
    "goal.success": "Objetivo alcanzado",
    "goal.warning": "No fue posible alcanzar los 700 KB",
    "result.success": "Objetivo alcanzado.",
    "result.warning": "No fue posible alcanzar los 700 KB sin degradar mas la legibilidad.",
    "states.0": "Validando PDF...",
    "states.1": "Probando compresion equilibrada...",
    "states.2": "Ajustando resolucion de imagenes...",
    "states.3": "Optimizando fuentes y metadatos...",
    "states.4": "Verificando el PDF resultante..."
  }
};

let selectedFile = null;
let progressTimer = null;
let currentLanguage = "en";
let lastResult = null;

function t(key) {
  return translations[currentLanguage][key] || translations.en[key] || key;
}

function setLanguage(language) {
  currentLanguage = translations[language] ? language : "en";
  localStorage.setItem("pdf-compressor-language", currentLanguage);
  document.documentElement.lang = currentLanguage;

  document.querySelectorAll("[data-i18n]").forEach((element) => {
    element.textContent = t(element.dataset.i18n);
  });

  languageButtons.forEach((button) => {
    const isActive = button.dataset.language === currentLanguage;
    button.classList.toggle("is-active", isActive);
    button.setAttribute("aria-pressed", String(isActive));
  });

  if (!statusPanel.hidden && !progressArea.hidden) {
    statusText.textContent = t("progress.prepare");
  }
  if (lastResult && !resultArea.hidden) {
    renderResultText(lastResult);
  }
}

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
    showError(t("validation.invalidPdf"));
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
  statusText.textContent = t(`states.${index}`);
  progressTimer = window.setInterval(() => {
    progress = Math.min(progress + Math.random() * 12, 88);
    index = Math.min(index + 1, 4);
    progressBar.style.width = `${progress}%`;
    statusText.textContent = t(`states.${index}`);
  }, 850);
}

function stopProgress() {
  window.clearInterval(progressTimer);
  progressBar.style.width = "100%";
}

function renderResultText(data) {
  goalBadge.textContent = data.target_reached ? t("goal.success") : t("goal.warning");
  goalBadge.className = `goal-badge ${data.target_reached ? "success" : "warning"}`;
  resultMessage.textContent = data.target_reached ? t("result.success") : t("result.warning");
}

function showResult(data) {
  lastResult = data;
  progressArea.hidden = true;
  resultArea.hidden = false;
  renderResultText(data);
  originalSize.textContent = formatBytes(data.original_size);
  compressedSize.textContent = formatBytes(data.compressed_size);
  reduction.textContent = `${data.reduction_percentage}%`;
  downloadLink.href = `/api/download/${data.download_id}`;
  downloadLink.setAttribute("download", data.output_filename);
}

languageButtons.forEach((button) => {
  button.addEventListener("click", () => setLanguage(button.dataset.language));
});

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
    const response = await fetch("/api/compress", {
      method: "POST",
      body,
      headers: {
        "X-App-Language": currentLanguage
      }
    });
    const data = await response.json();
    if (!response.ok) {
      throw new Error(data.detail || t("errors.generic"));
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
  lastResult = null;
  clearError();
});

setLanguage(localStorage.getItem("pdf-compressor-language") || "en");
