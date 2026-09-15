DECLARE @BaseOrigen  sysname = N'DBA_LAB_CORE';
DECLARE @BaseDestino sysname = N'DBA_LAB_RESTORE';

DECLARE @FechaFull datetime;

-- Obtiene la fecha de finalización del último FULL normal.
-- Excluye backups COPY_ONLY.
SELECT TOP (1)
    @FechaFull = bs.backup_finish_date
FROM msdb.dbo.backupset AS bs
WHERE bs.database_name = @BaseOrigen
  AND bs.type = 'D'
  AND bs.is_copy_only = 0
  AND bs.backup_finish_date IS NOT NULL
ORDER BY bs.backup_finish_date DESC;

SELECT @FechaFull AS FechaUltimoFull;

-- Genera los RESTORE LOG posteriores al último FULL.
SELECT
    bs.backup_start_date,
    bs.backup_finish_date,
    bs.first_lsn,
    bs.last_lsn,
    bmf.physical_device_name,
    'RESTORE LOG ' + QUOTENAME(@BaseDestino) +
    ' FROM DISK = N''' +
    REPLACE(bmf.physical_device_name, '''', '''''') +
    ''' WITH NORECOVERY, STATS = 10;'
        AS ComandoRestore
FROM msdb.dbo.backupset AS bs
INNER JOIN msdb.dbo.backupmediafamily AS bmf
    ON bs.media_set_id = bmf.media_set_id
WHERE bs.database_name = @BaseOrigen
  AND bs.type = 'L'
  AND bs.backup_finish_date > @FechaFull
ORDER BY
    bs.first_lsn,
    bs.backup_start_date;