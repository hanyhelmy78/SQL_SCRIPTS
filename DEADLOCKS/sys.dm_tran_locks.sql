SELECT request_session_id, COUNT (*) num_locks
FROM sys.dm_tran_locks
GROUP BY request_session_id 
ORDER BY count (*) DESC

-- kill 54

-- kill 107 with statusonly

-- LOCK (THE 1st SESSION): When any session needs access to a piece of data from Database, a lock is held/placed on that data to maintain the isolation property of the database.

-- BLOCK (THE 2nd SESSION): When a session needs to wait for a resource being locked by another session.

-- DEADLOCK: When two sessions are waiting for a lock to clear on the other while holding it’s own resources.