PRINT 'Creating database...';

CREATE DATABASE CentroMedico;
USE CentroMedico;

:R ".\CentroMedico\Types.sql"

:R ".\CentroMedico\TablaPais.sql"
:R ".\CentroMedico\TablaEspecialidad.sql"
:R ".\CentroMedico\TablaConcepto.sql"
:R ".\CentroMedico\TablaTurnoEstado.sql"

:R ".\CentroMedico\TablaPaciente.sql"
:R ".\CentroMedico\TablaMedico.sql"
:R ".\CentroMedico\TablaHistoria.sql"
:R ".\CentroMedico\TablaTurno.sql"
:R ".\CentroMedico\TablaPago.sql"

:R ".\CentroMedico\TablaHistoriaPaciente.sql"
:R ".\CentroMedico\TablaPagoPaciente.sql"
:R ".\CentroMedico\TablaTurnoPaciente.sql"

PRINT 'Database created.';