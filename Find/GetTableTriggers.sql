SELECT DISTINCT	o.[name] AS [Table], tr.[name] AS [Trigger]--, tr.Status
FROM	[sysobjects] o
JOIN	[sysobjects] tr
	ON	o.[id] = tr.[parent_obj]
WHERE	tr.[type] = 'tr' and tr.[name] like '%$%'
ORDER BY [Table], [Trigger]