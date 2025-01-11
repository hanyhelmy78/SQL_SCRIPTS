SELECT message_id,severity,text
FROM sys.messages 
WHERE is_event_logged = 1 
  and language_id = 1033
  AND ((severity BETWEEN 16 AND 26) OR message_id IN(
823,
824,
825,
832,
855,
856,
1480,
19406,
35250,
35254,
35264,
35267,
35273,
35274,
35275,
35276,
35279,
41091,
41131,
41142,
41406,
41414,
64000,
64001))