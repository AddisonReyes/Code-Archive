--- Session C ---

SELECT 
	session_id, blocking_session_id, status, 
	wait_type, wait_time, wait_resource
FROM sys.dm_exec_requests
WHERE 
	blocking_session_id <> 0
	OR session_id IN (@@SPID);
