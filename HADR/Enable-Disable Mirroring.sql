 --************************** DISABLE ABC REPLICATION FIRST *********************************
--==========================================================================================
-- To CONVERT TO SYNCHRONOUS MODE

ALTER DATABASE [ABP_BMB] SET SAFETY FULL
ALTER DATABASE [ABP_SFA_BMB] SET SAFETY FULL

ALTER DATABASE [PEPSI] SET SAFETY FULL
--===========================================================
-- To FAILOVER

ALTER DATABASE [ABP_BMB] SET PARTNER FAILOVER;
ALTER DATABASE [ABP_SFA_BMB] SET PARTNER FAILOVER;

ALTER DATABASE [PEPSI] SET PARTNER FAILOVER;
--===========================================================
-- AFTER FAILBACK TO PRODUCTION RETURN TO ASYNCHRONOUS MODE

ALTER DATABASE [ABP_BMB] SET SAFETY OFF
ALTER DATABASE [ABP_SFA_BMB] SET SAFETY OFF

ALTER DATABASE [PEPSI] SET SAFETY OFF
--=========================================================
-- To temporary PAUSE the Mirroring for a specific DB

ALTER DATABASE UPSLT2 SET PARTNER SUSPEND;
ALTER DATABASE [ABP_SFA_BMB] SET PARTNER SUSPEND;
ALTER DATABASE [PEPSI] SET PARTNER SUSPEND;

-- To enable the Mirroring
ALTER DATABASE UPSLT2 SET PARTNER RESUME;
--==========================================================
-- 2 COMPLETELY REMOVE THE MIRRORING:

--ALTER DATABASE UPSLT2 SET PARTNER OFF;
--ALTER DATABASE [ABP_SFA_BMB] SET PARTNER OFF;
--ALTER DATABASE [PEPSI] SET PARTNER OFF;
--=============================================================