USE [BIOSERVER];
Create Clustered index [indx_AU_Template] on [AU_Template]
                           ([TemplateIndex] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_AU_UnitTemplate] on [AU_UnitTemplate]
                           ([TemplateIndex] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_CustomCodeName] on [CustomCodeName]
                           ([NameID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_EthernetCommunicationChannel] on [EthernetCommunicationChannel]
                           ([Port] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PanelConfigurationParameter] on [PanelConfigurationParameter]
                           ([ID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_SerialCommunicationChannel] on [SerialCommunicationChannel]
                           ([NetworkId] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_SharedPrivileges] on [SharedPrivileges]
                           ([SharedPrivilegeId] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Template2SmartCard] on [Template2SmartCard]
                           ([SmartCardId] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_UnitTemplate] on [UnitTemplate]
                           ([TemplateIndex] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
USE [HISGENX_MEDICALRECORD];
USE [HISGENX];
Create Clustered index [indx_CompanyInfoTransfer] on [CompanyInfoTransfer]
                           ([ProcClassID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_DBStatistics] on [DBStatistics]
                           ([Reads] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_EMR_BasicActivitySupport] on [EMR_BasicActivitySupport]
                           ([Srno] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_EMR_FluidBalanceSupport] on [EMR_FluidBalanceSupport]
                           ([IV FLUID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_EMR_HendRich11FallRiskAssessmentSupport] on [EMR_HendRich11FallRiskAssessmentSupport]
                           ([FallRiskCriteria] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_EMR_MrsaScreeningDocumentSupport] on [EMR_MrsaScreeningDocumentSupport]
                           ([Remark] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_EMR_NortonScaleScore2] on [EMR_NortonScaleScore2]
                           ([OTHER RISK] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_EMR_PhysicalMaturity] on [EMR_PhysicalMaturity]
                           ([Sign Score] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_AdaptedMachesterSupport] on [HIS_AdaptedMachesterSupport]
                           ([LevelID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_CompanyGroup_Original] on [HIS_CompanyGroup_Original]
                           ([CreatedBy] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_ICD10_AM_DICTION] on [HIS_ICD10_AM_DICTION]
                           ([CreatedBy] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_ICD10_AM_DISEASE_Copy] on [HIS_ICD10_AM_DISEASE_Copy]
                           ([CodeLength] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_IncomeShareDocPaySlip_Temp] on [HIS_IncomeShareDocPaySlip_Temp]
                           ([TransactionNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_InPatientRoomCheckListSupport] on [HIS_InPatientRoomCheckListSupport]
                           ([SrNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_InvoiceAdvanceLog] on [HIS_InvoiceAdvanceLog]
                           ([InvoiceNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_InvoiceDetailLog] on [HIS_InvoiceDetailLog]
                           ([InvoiceNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_LaborDeliveryRoomSupport] on [HIS_LaborDeliveryRoomSupport]
                           ([SrNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_NursingCarePlanSupport] on [HIS_NursingCarePlanSupport]
                           ([SrNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_NursingParameter] on [HIS_NursingParameter]
                           ([ParameterCode] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_OperationalDefinitionsForNeonatal] on [HIS_OperationalDefinitionsForNeonatal]
                           ([SrNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_PatientDemographic_bkp] on [HIS_PatientDemographic_bkp]
                           ([PatientID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_PatientTransition] on [HIS_PatientTransition]
                           ([PatientID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_PreOperativeCheckListSupport] on [HIS_PreOperativeCheckListSupport]
                           ([SrNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_PROCEDURETemp] on [HIS_PROCEDURETemp]
                           ([CreatedBy] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_HIS_ReferralDoctorTemp] on [HIS_ReferralDoctorTemp]
                           ([ReferralProviderID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PriceUpdate] on [PriceUpdate]
                           ([ProcedureID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_ProjectWiseReport] on [ProjectWiseReport]
                           ([TotalAppts] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_STP_PaymentModeAuthorizationMapping] on [STP_PaymentModeAuthorizationMapping]
                           ([CreatedBy] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Tmp_LAB_BloodTransfusionRequest] on [Tmp_LAB_BloodTransfusionRequest]
                           ([RequestNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
USE [LAB_ORDER];
USE [LAB_RESULT];
Create Clustered index [indx_LabOrder] on [LabOrder]
                           ([OrderControlType] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Patient] on [Patient]
                           ([PatientInternalID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
USE [PHARMAKON];
Create Clustered index [indx_ItemArabic] on [ItemArabic]
                           ([ItemId] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PHR_InventoryUpdate] on [PHR_InventoryUpdate]
                           ([Year] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PHR_ItemVendor] on [PHR_ItemVendor]
                           ([ItemID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PHR_ReorderWsSales] on [PHR_ReorderWsSales]
                           ([ItemId] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PhysicalCountTotal] on [PhysicalCountTotal]
                           ([ItemCode] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Table2Delete] on [Table2Delete]
                           ([InvoiceNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_TestTable] on [TestTable]
                           ([ItemID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_UpdateCharges] on [UpdateCharges]
                           ([PatientID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
USE [RIS_ORDER];
USE [RIS_RESULT];
Create Clustered index [indx_RIS_Order] on [RIS_Order]
                           ([OBRSetID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_RIS_Report] on [RIS_Report]
                           ([OrderNumber] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
USE [SENTRY];
Create Clustered index [indx_STP_ReportParameter] on [STP_ReportParameter]
                           ([MedicalAdminID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Temp] on [Temp]
                           ([ID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Temp_Mem_Update] on [Temp_Mem_Update]
                           ([old_empid] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
USE [BAHRAINIFAD];
Create Clustered index [indx_AP_CRDRN_RECONS_TEMP] on [AP_CRDRN_RECONS_TEMP]
                           ([CR_COMP_CODE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_APRPT010_1] on [APRPT010_1]
                           ([RPT101_COMP_CODE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_APRPT010_2] on [APRPT010_2]
                           ([RPT102_COMP_CODE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_APRPT011] on [APRPT011]
                           ([R11_COMP_CODE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_APRPT012] on [APRPT012]
                           ([R12_COMP_CODE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_AS_DEPN_Temp] on [AS_DEPN_Temp]
                           ([DPN_COMP] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_assettmp] on [assettmp]
                           ([ass_asset_] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_asstran] on [asstran]
                           ([ass_asset_] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_FXALLOW] on [FXALLOW]
                           ([FI_TRCD] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_FXDEDN] on [FXDEDN]
                           ([FI_TRCD] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_GL_GL_BAL_TEMP1] on [GL_GL_BAL_TEMP1]
                           ([GB_COMP_CODE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_GL_JV_DTLS_TEMP1] on [GL_JV_DTLS_TEMP1]
                           ([JD_COMP_CODE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_GL_REP_DTL] on [GL_REP_DTL]
                           ([USER_ID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_GL_REP_DTL_TMP] on [GL_REP_DTL_TMP]
                           ([USER_ID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_GL_SL_BAL_TEMP] on [GL_SL_BAL_TEMP]
                           ([SB_COMP_CODE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_GL_SL_BAL_TEMP1] on [GL_SL_BAL_TEMP1]
                           ([SB_COMP_CODE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_GOSI_DeductionTemp] on [GOSI_DeductionTemp]
                           ([EmployeeID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_IN_GL_DICT] on [IN_GL_DICT]
                           ([GL_INWARD_DR] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_IN_MR_APPROVALS] on [IN_MR_APPROVALS]
                           ([ApprovalLevel] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_IN_MR_DETAIL] on [IN_MR_DETAIL]
                           ([SlNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_IN_MR_HEADER] on [IN_MR_HEADER]
                           ([DeptNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_LeaveClearence] on [LeaveClearence]
                           ([Fin_AccruedServAward] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_messages] on [messages]
                           ([msgdefaultbutton] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_MS_Maintenence] on [MS_Maintenence]
                           ([TransNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_MS_Section] on [MS_Section]
                           ([SectionName] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PAMTHDAY] on [PAMTHDAY]
                           ([MTH_CD] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_pbcatcol] on [pbcatcol]
                           ([pbc_tid] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_pbcatedt] on [pbcatedt]
                           ([pbe_cntr] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_pbcatfmt] on [pbcatfmt]
                           ([pbf_cntr] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_pbcattbl] on [pbcattbl]
                           ([pbt_tid] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_pbcatvld] on [pbcatvld]
                           ([pbv_cntr] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PEMISC] on [PEMISC]
                           ([MI_YYYYMM] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PER_PASSPORT_INOUT] on [PER_PASSPORT_INOUT]
                           ([SLNO] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PER_VISACONTROLLER] on [PER_VISACONTROLLER]
                           ([SLNO] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PO_DETAIL_COPY] on [PO_DETAIL_COPY]
                           ([PONO] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PPS_ALLOWN1_TMP] on [PPS_ALLOWN1_TMP]
                           ([AT_FIXED] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PPS_DOC_ACCNT_INFO] on [PPS_DOC_ACCNT_INFO]
                           ([EmpId] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PPS_REPT025] on [PPS_REPT025]
                           ([ST_EMPCD] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PPS_REPT027] on [PPS_REPT027]
                           ([ST_EMPCD] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PR_DETAIL_copy] on [PR_DETAIL_copy]
                           ([LOGNO] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PR_HEADER_copy] on [PR_HEADER_copy]
                           ([LOGNO] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_PROMOV] on [PROMOV]
                           ([PM_BRAN] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_RW_ADDR_TMP] on [RW_ADDR_TMP]
                           ([APH_CURR_CODE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_RW_INCR_TMP] on [RW_INCR_TMP]
                           ([APH_CURR_CODE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_SE_DELETE_LOG] on [SE_DELETE_LOG]
                           ([TABLENAME] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Tap_Employee_User_Link] on [Tap_Employee_User_Link]
                           ([EmployeeId] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_TapReg_Employee] on [TapReg_Employee]
                           ([EmpId] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_TelephoneDirectory] on [TelephoneDirectory]
                           ([CreUser] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_TempPastatic] on [TempPastatic]
                           ([EmpCd] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Tmp_HousingJobOrderPurchaseHdr] on [Tmp_HousingJobOrderPurchaseHdr]
                           ([TransNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_TSK_DETAIL] on [TSK_DETAIL]
                           ([prjno] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Web_Ad_Supplier] on [Web_Ad_Supplier]
                           ([SupplierCode] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Web_MediaInvDtl] on [Web_MediaInvDtl]
                           ([TransNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Web_MediaInvHdr] on [Web_MediaInvHdr]
                           ([TransNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Web_MediaList] on [Web_MediaList]
                           ([MediaCode] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Web_MediaParameter] on [Web_MediaParameter]
                           ([ParameterName] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Web_MediaSection] on [Web_MediaSection]
                           ([SectionName] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Zfx_SubOrdinate] on [Zfx_SubOrdinate]
                           ([EmpType] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_zNonmoving] on [zNonmoving]
                           ([itemcode] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
USE [HRMS];
Create Clustered index [indx_Approved Job] on [Approved Job]
                           ([EndDate] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_CandidateList] on [CandidateList]
                           ([current Status] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_CAT_LeaveType_In_PPS_LeaveType] on [CAT_LeaveType_In_PPS_LeaveType]
                           ([PpsLeaveCode] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Employee] on [Employee]
                           ([EmployeeNo] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_pbcatcol] on [pbcatcol]
                           ([pbc_tid] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_pbcatedt] on [pbcatedt]
                           ([pbe_cntr] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_pbcatfmt] on [pbcatfmt]
                           ([pbf_cntr] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_pbcattbl] on [pbcattbl]
                           ([pbt_tid] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_pbcatvld] on [pbcatvld]
                           ([pbv_cntr] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_STP_ParameterIFAD] on [STP_ParameterIFAD]
                           ([SYTYPE] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_Stp_TempSalaryScale] on [Stp_TempSalaryScale]
                           ([PositionCode] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_STP_TransactionCandidateProcessMap] on [STP_TransactionCandidateProcessMap]
                           ([TransactionTypeId] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_tempIVFData] on [tempIVFData]
                           ([UnitNmae] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_tempRepository] on [tempRepository]
                           ([Gender] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_TempSTP_City] on [TempSTP_City]
                           ([CreatedBy] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO
Create Clustered index [indx_TempTKUnderProcessCandidate] on [TempTKUnderProcessCandidate]
                           ([PositionCodeID] ASC) with (Fillfactor=100,Data_Compression=page)
                           GO