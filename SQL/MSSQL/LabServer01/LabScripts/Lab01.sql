SELECT
	@@SERVERNAME AS ServerName,
	@@VERSION AS VersionInfo;

---

SELECT
	name,
	state_desc,
	recovery_model_desc
FROM sys.databases
ORDER BY name;