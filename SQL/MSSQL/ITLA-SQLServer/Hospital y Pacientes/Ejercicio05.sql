USE hospital_db

CREATE INDEX idx_paciente_cedula
ON pacientes(cedula);

CREATE INDEX idx_medico_especialidad
ON medicos(especialidad);

ALTER TABLE pacientes
ADD correo VARCHAR(150);

ALTER TABLE medicamentos
ALTER COLUMN nombre VARCHAR(180);