/*
https://stackoverflow.com/questions/155246/how-do-you-truncate-all-tables-in-a-database-using-tsql#:~:text=The%20simplest%20way%20of%20doing%20this%20is%20to
1- open up SQL Management Studio
2- navigate to your database
3- Right-click and select Tasks->Generate Scripts (pic 1)
4- On the "choose Objects" screen, select the "select specific objects" option and check "tables" (pic 2)
5- on the next screen, select "advanced" and then change the "Script DROP and CREATE" option to "Script DROP and CREATE" (pic 3)
6- Choose to save script to a new editor window or a file and run as necessary.
*/
USE [NusukCore_UAT]
GO
ALTER TABLE [Packages].[TransportationSpecialContractRoute] DROP CONSTRAINT [FK_TransportationSpecialContractRoute_TransportationSpecialContract_TransportationSpecialContractId]
GO
ALTER TABLE [Packages].[TransportationSpecialContract] DROP CONSTRAINT [FK_TransportationSpecialContract_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[ServiceProviderPhoto] DROP CONSTRAINT [FK_ServiceProviderPhoto_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[ServiceProviderPackageCategory] DROP CONSTRAINT [FK_ServiceProviderPackageCategory_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[ServiceProviderGroundCenter] DROP CONSTRAINT [FK_ServiceProviderGroundCenter_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[ServiceProviderAdditionalServices] DROP CONSTRAINT [FK_ServiceProviderAdditionalServices_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[PackageTransportationPath] DROP CONSTRAINT [FK_PackageTransportationPath_TransportationSpecialContract_TransportationSpecialContractId]
GO
ALTER TABLE [Packages].[PackageTransportationPath] DROP CONSTRAINT [FK_PackageTransportationPath_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[PackageTransportationPath] DROP CONSTRAINT [FK_PackageTransportationPath_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageServiceProviderAdditionalService] DROP CONSTRAINT [FK_PackageServiceProviderAdditionalService_ServiceProviderAdditionalServices_ServiceProviderAdditionalServiceId]
GO
ALTER TABLE [Packages].[PackageServiceProviderAdditionalService] DROP CONSTRAINT [FK_PackageServiceProviderAdditionalService_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[PackageServiceProviderAdditionalService] DROP CONSTRAINT [FK_PackageServiceProviderAdditionalService_Package_PackageId]
GO
ALTER TABLE [Packages].[PackagePhotos] DROP CONSTRAINT [FK_PackagePhotos_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageOperation] DROP CONSTRAINT [FK_PackageOperation_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[PackageOperation] DROP CONSTRAINT [FK_PackageOperation_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageHousingContractRoom] DROP CONSTRAINT [FK_PackageHousingContractRoom_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[PackageHousingContractRoom] DROP CONSTRAINT [FK_PackageHousingContractRoom_PackageHousingContract_PackageHousingContractId]
GO
ALTER TABLE [Packages].[PackageHousingContract] DROP CONSTRAINT [FK_PackageHousingContract_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageHousingContract] DROP CONSTRAINT [FK_PackageHousingContract_HousingContract_HousingContractId]
GO
ALTER TABLE [Packages].[PackageFoodContract] DROP CONSTRAINT [FK_PackageFoodContract_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[PackageFoodContract] DROP CONSTRAINT [FK_PackageFoodContract_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageFoodContract] DROP CONSTRAINT [FK_PackageFoodContract_FoodContract_FoodContractId]
GO
ALTER TABLE [Packages].[PackageFlightContract] DROP CONSTRAINT [FK_PackageFlightContract_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageFlightContract] DROP CONSTRAINT [FK_PackageFlightContract_FlightContract_FlightContractId]
GO
ALTER TABLE [Packages].[Package] DROP CONSTRAINT [FK_Package_ServiceProviderGroundCenter_MakkahGroundCenterId]
GO
ALTER TABLE [Packages].[Package] DROP CONSTRAINT [FK_Package_ServiceProviderGroundCenter_MadinahGroundCenterId]
GO
ALTER TABLE [Packages].[Package] DROP CONSTRAINT [FK_Package_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[HousingContractRoom] DROP CONSTRAINT [FK_HousingContractRoom_HousingContract_HousingContractId]
GO
ALTER TABLE [Packages].[HousingContractMeal] DROP CONSTRAINT [FK_HousingContractMeal_HousingContract_HousingContractId]
GO
ALTER TABLE [Packages].[HousingContract] DROP CONSTRAINT [FK_HousingContract_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[FoodContractMenu] DROP CONSTRAINT [FK_FoodContractMenu_FoodContract_FoodContractId]
GO
ALTER TABLE [Packages].[FoodContract] DROP CONSTRAINT [FK_FoodContract_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[FlightRoute] DROP CONSTRAINT [FK_FlightRoute_FlightTrip_FlightTripId]
GO
ALTER TABLE [Packages].[FlightContractCountry] DROP CONSTRAINT [FK_FlightContractCountry_FlightContract_FlightContractId]
GO
ALTER TABLE [Packages].[FlightContract] DROP CONSTRAINT [FK_FlightContract_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[FlightContract] DROP CONSTRAINT [FK_FlightContract_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[FlightContract] DROP CONSTRAINT [FK_FlightContract_FlightTrip_ReturnTripId]
GO
ALTER TABLE [Packages].[FlightContract] DROP CONSTRAINT [FK_FlightContract_FlightTrip_ArrivalTripId]
GO
ALTER TABLE [Notifications].[RequestAction] DROP CONSTRAINT [FK_RequestAction_Notification_NotificationId]
GO
ALTER TABLE [MoneyFunds].[WalletTransactionDetail] DROP CONSTRAINT [FK_WalletTransactionDetail_WalletTransaction_WalletTransactionId]
GO
ALTER TABLE [MoneyFunds].[WalletTransactionDetail] DROP CONSTRAINT [FK_WalletTransactionDetail_Wallet_WalletId]
GO
ALTER TABLE [MoneyFunds].[WalletTransaction] DROP CONSTRAINT [FK_WalletTransaction_Wallet_WalletId]
GO
ALTER TABLE [MoneyFunds].[WalletRefundTransaction] DROP CONSTRAINT [FK_WalletRefundTransaction_WalletTransaction_WalletTransactionId]
GO
ALTER TABLE [MoneyFunds].[WalletDiscount] DROP CONSTRAINT [FK_WalletDiscount_Wallet_WalletId]
GO
ALTER TABLE [MoneyFunds].[BillingAddress] DROP CONSTRAINT [FK_BillingAddress_Wallet_WalletId]
GO
ALTER TABLE [MoneyFunds].[BankDetail] DROP CONSTRAINT [FK_BankDetail_Wallet_WalletId]
GO
ALTER TABLE [Applicants].[ApplicantVisaAnswer] DROP CONSTRAINT [FK_ApplicantVisaAnswer_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantTravelHistory] DROP CONSTRAINT [FK_ApplicantTravelHistory_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantRelativeResident] DROP CONSTRAINT [FK_ApplicantRelativeResident_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantRejectionReason] DROP CONSTRAINT [FK_ApplicantRejectionReason_ApplicantHistory_ApplicantHistoryId]
GO
ALTER TABLE [Applicants].[ApplicantPreference] DROP CONSTRAINT [FK_ApplicantPreference_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantOtherNationality] DROP CONSTRAINT [FK_ApplicantOtherNationality_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantOccupationDetail] DROP CONSTRAINT [FK_ApplicantOccupationDetail_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantHistory] DROP CONSTRAINT [FK_ApplicantHistory_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantDocument] DROP CONSTRAINT [FK_ApplicantDocument_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantContactDetail] DROP CONSTRAINT [FK_ApplicantContactDetail_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantBankDetail] DROP CONSTRAINT [FK_ApplicantBankDetail_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantArrivalDetail] DROP CONSTRAINT [FK_ApplicantArrivalDetail_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantAllergy] DROP CONSTRAINT [FK_ApplicantAllergy_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[Applicant] DROP CONSTRAINT [FK_Applicant_Application_ApplicationId]
GO
ALTER TABLE [Admins].[TourGuideRegistrationPilgrimException] DROP CONSTRAINT [FK_TourGuideRegistrationPilgrimException_TourGuideRegistration_TourGuideRegistrationId]
GO
ALTER TABLE [Admins].[TourGuideRegistrationPeriodException] DROP CONSTRAINT [FK_TourGuideRegistrationPeriodException_TourGuideRegistration_TourGuideRegistrationId]
GO
ALTER TABLE [Admins].[ServiceCenterWorkHours] DROP CONSTRAINT [FK_ServiceCenterWorkHours_ServiceCenter_ServiceCenterId]
GO
ALTER TABLE [Admins].[ServiceCenterAppointment] DROP CONSTRAINT [FK_ServiceCenterAppointment_ServiceCenter_ServiceCenterId]
GO
ALTER TABLE [Admins].[ServiceCenter] DROP CONSTRAINT [FK_ServiceCenter_Country_CountryId]
GO
ALTER TABLE [Admins].[ReservationPeriodException] DROP CONSTRAINT [FK_ReservationPeriodException_ReservationPeriod_ReservationPeriodId]
GO
ALTER TABLE [Admins].[ReservationPeriodException] DROP CONSTRAINT [FK_ReservationPeriodException_Country_CountryId]
GO
ALTER TABLE [Admins].[PackageCategory] DROP CONSTRAINT [FK_PackageCategory_HousingZone_HousingZoneId]
GO
ALTER TABLE [Admins].[LookupLocalization] DROP CONSTRAINT [FK_LookupLocalization_SystemLanguage_SystemLanguageId]
GO
ALTER TABLE [Admins].[HousingProviderService] DROP CONSTRAINT [FK_HousingProviderService_HousingProvider_HousingProviderId]
GO
ALTER TABLE [Admins].[HousingProviderRepresentativeContact] DROP CONSTRAINT [FK_HousingProviderRepresentativeContact_HousingProvider_HousingProviderId]
GO
ALTER TABLE [Admins].[HousingProviderPhoto] DROP CONSTRAINT [FK_HousingProviderPhoto_HousingProvider_HousingProviderId]
GO
ALTER TABLE [Admins].[HousingProvider] DROP CONSTRAINT [FK_HousingProvider_HousingZone_HousingZoneId]
GO
ALTER TABLE [Admins].[HousingProvider] DROP CONSTRAINT [FK_HousingProvider_City_CityId]
GO
ALTER TABLE [Admins].[EmbassyQuota] DROP CONSTRAINT [FK_EmbassyQuota_Embassy_EmbassyId]
GO
ALTER TABLE [Admins].[EmbassyQuota] DROP CONSTRAINT [FK_EmbassyQuota_Country_CountryId]
GO
ALTER TABLE [Admins].[CountryNote] DROP CONSTRAINT [FK_CountryNote_Country_CountryId]
GO
ALTER TABLE [Admins].[CountryGroup] DROP CONSTRAINT [FK_CountryGroup_Country_CountryId]
GO
ALTER TABLE [Admins].[CountryAllowedAge] DROP CONSTRAINT [FK_CountryAllowedAge_Country_CountryId]
GO
ALTER TABLE [Admins].[Country] DROP CONSTRAINT [FK_Country_Continent_ContinentId]
GO
ALTER TABLE [Admins].[City] DROP CONSTRAINT [FK_City_Country_CountryId]
GO
ALTER TABLE [Admins].[CampTransportation] DROP CONSTRAINT [FK_CampTransportation_SystemLanguage_SystemLanguageId]
GO
ALTER TABLE [Admins].[CampTransportation] DROP CONSTRAINT [FK_CampTransportation_Camp_CampId]
GO
ALTER TABLE [Admins].[CampPackageCategory] DROP CONSTRAINT [FK_CampPackageCategory_Camp_CampId]
GO
ALTER TABLE [Admins].[CampMedia] DROP CONSTRAINT [FK_CampMedia_Camp_CampId]
GO
ALTER TABLE [Admins].[AdditionalService] DROP CONSTRAINT [FK_AdditionalService_AdditionalServiceType_AdditionalServiceTypeId]
GO
ALTER TABLE [Packages].[TransportationSpecialContractRoute] DROP CONSTRAINT [DF__Transport__Price__61F08603]
GO
ALTER TABLE [Packages].[TransportationSpecialContractRoute] DROP CONSTRAINT [DF__Transport__Trans__39E294A9]
GO
ALTER TABLE [Packages].[TransportationSpecialContractRoute] DROP CONSTRAINT [DF__Transport__Capac__25DB9BFC]
GO
ALTER TABLE [Packages].[TransportationSpecialContractRoute] DROP CONSTRAINT [DF__Transport__Trans__056ECC6A]
GO
ALTER TABLE [Packages].[TransportationSpecialContract] DROP CONSTRAINT [DF__Transport__IsAct__26CFC035]
GO
ALTER TABLE [Packages].[ServiceProviderAdditionalServices] DROP CONSTRAINT [DF__ServicePr__Photo__23F3538A]
GO
ALTER TABLE [Packages].[ServiceProvider] DROP CONSTRAINT [DF__ServicePr__Minis__0DCF0841]
GO
ALTER TABLE [Packages].[ServiceProvider] DROP CONSTRAINT [DF__ServicePr__Court__0CDAE408]
GO
ALTER TABLE [Packages].[ServiceProvider] DROP CONSTRAINT [DF__ServicePr__B2CQu__0BE6BFCF]
GO
ALTER TABLE [Packages].[ServiceProvider] DROP CONSTRAINT [DF__ServicePr__Allow__60FC61CA]
GO
ALTER TABLE [Packages].[ServiceProvider] DROP CONSTRAINT [DF__ServicePr__Allow__60083D91]
GO
ALTER TABLE [Packages].[PricingStructure] DROP CONSTRAINT [DF__PricingSt__BaseV__3429BB53]
GO
ALTER TABLE [Packages].[PricingStructure] DROP CONSTRAINT [DF__PricingSt__BaseP__3335971A]
GO
ALTER TABLE [Packages].[PackageTransportationPath] DROP CONSTRAINT [DF__PackageTr__Price__3DB3258D]
GO
ALTER TABLE [Packages].[PackageServiceProviderAdditionalService] DROP CONSTRAINT [DF__PackageSe__Price__3EA749C6]
GO
ALTER TABLE [Packages].[PackagePhotos] DROP CONSTRAINT [DF__PackagePh__Photo__24E777C3]
GO
ALTER TABLE [Packages].[PackageHousingContractRoom] DROP CONSTRAINT [DF__PackageHo__Price__3F9B6DFF]
GO
ALTER TABLE [Packages].[PackageFoodContract] DROP CONSTRAINT [DF__PackageFo__Price__408F9238]
GO
ALTER TABLE [Packages].[Package] DROP CONSTRAINT [DF__Package__MakkahG__178D7CA5]
GO
ALTER TABLE [Packages].[Package] DROP CONSTRAINT [DF__Package__QuotaTy__0662F0A3]
GO
ALTER TABLE [Packages].[HousingContractRoom] DROP CONSTRAINT [DF__HousingCo__Housi__075714DC]
GO
ALTER TABLE [Packages].[HousingContract] DROP CONSTRAINT [DF__HousingCo__Total__2AA05119]
GO
ALTER TABLE [Packages].[HousingContract] DROP CONSTRAINT [DF__HousingCo__Price__29AC2CE0]
GO
ALTER TABLE [Packages].[HousingContract] DROP CONSTRAINT [DF__HousingCo__IsAct__28B808A7]
GO
ALTER TABLE [Packages].[HousingContract] DROP CONSTRAINT [DF__HousingCo__House__27C3E46E]
GO
ALTER TABLE [Packages].[FoodContractMenu] DROP CONSTRAINT [DF__FoodContr__FoodC__084B3915]
GO
ALTER TABLE [Packages].[FoodContract] DROP CONSTRAINT [DF__FoodContr__MealT__62E4AA3C]
GO
ALTER TABLE [Packages].[FoodContract] DROP CONSTRAINT [DF__FoodContr__Price__2C88998B]
GO
ALTER TABLE [Packages].[FoodContract] DROP CONSTRAINT [DF__FoodContr__IsAct__2B947552]
GO
ALTER TABLE [Packages].[FlightRoute] DROP CONSTRAINT [DF__FlightRou__Depar__0FB750B3]
GO
ALTER TABLE [Packages].[FlightRoute] DROP CONSTRAINT [DF__FlightRou__Arriv__0EC32C7A]
GO
ALTER TABLE [Packages].[FlightContract] DROP CONSTRAINT [DF__FlightCon__Capac__7E8CC4B1]
GO
ALTER TABLE [Applicants].[ApplicantPreference] DROP CONSTRAINT [DF__Applicant__Asthm__4D5F7D71]
GO
ALTER TABLE [Applicants].[ApplicantDeleteReason] DROP CONSTRAINT [DF__Applicant__Appli__76619304]
GO
ALTER TABLE [Applicants].[Applicant] DROP CONSTRAINT [DF__Applicant__IsMai__1BC821DD]
GO
ALTER TABLE [Admins].[TransportationPath] DROP CONSTRAINT [DF__Transport__Total__46486B8E]
GO
ALTER TABLE [Admins].[TransportationPath] DROP CONSTRAINT [DF__Transport__Price__45544755]
GO
ALTER TABLE [Admins].[TourGuideRegistration] DROP CONSTRAINT [DF__TourGuide__MinPi__3AD6B8E2]
GO
ALTER TABLE [Admins].[ServiceCenterAppointment] DROP CONSTRAINT [DF__ServiceCen__Time__5E8A0973]
GO
ALTER TABLE [Admins].[ServiceCenterAppointment] DROP CONSTRAINT [DF__ServiceCe__Mobil__5CA1C101]
GO
ALTER TABLE [Admins].[ServiceCenterAppointment] DROP CONSTRAINT [DF__ServiceCe__Email__5BAD9CC8]
GO
ALTER TABLE [Admins].[ServiceCenter] DROP CONSTRAINT [DF__ServiceCe__IsHel__57DD0BE4]
GO
ALTER TABLE [Admins].[PackageCategory] DROP CONSTRAINT [DF__PackageCa__Ratin__4D2A7347]
GO
ALTER TABLE [Admins].[PackageCategory] DROP CONSTRAINT [DF__PackageCa__Ratin__4C364F0E]
GO
ALTER TABLE [Admins].[PackageCategory] DROP CONSTRAINT [DF__PackageCa__Packa__29E1370A]
GO
ALTER TABLE [Admins].[PackageCategory] DROP CONSTRAINT [DF__PackageCa__IsTou__28ED12D1]
GO
ALTER TABLE [Admins].[PackageCategory] DROP CONSTRAINT [DF__PackageCa__IsMad__27F8EE98]
GO
ALTER TABLE [Admins].[PackageCategory] DROP CONSTRAINT [DF__PackageCa__Quota__2057CCD0]
GO
ALTER TABLE [Admins].[HousingProvider] DROP CONSTRAINT [DF__HousingPr__TripA__07220AB2]
GO
ALTER TABLE [Admins].[HousingProvider] DROP CONSTRAINT [DF__HousingPr__TripA__062DE679]
GO
ALTER TABLE [Admins].[HousingProvider] DROP CONSTRAINT [DF__HousingPr__Booki__0539C240]
GO
ALTER TABLE [Admins].[HousingProvider] DROP CONSTRAINT [DF__HousingPr__Booki__04459E07]
GO
ALTER TABLE [Admins].[HousingProvider] DROP CONSTRAINT [DF__HousingPr__Descr__75F77EB0]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] DROP CONSTRAINT [DF__GlobalQuo__IsMin__1293BD5E]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] DROP CONSTRAINT [DF__GlobalQuo__IsCou__119F9925]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] DROP CONSTRAINT [DF__GlobalQuo__IsB2C__10AB74EC]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] DROP CONSTRAINT [DF__GlobalQuo__Avail__00DF2177]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] DROP CONSTRAINT [DF__GlobalQuo__Avail__7FEAFD3E]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] DROP CONSTRAINT [DF__GlobalQuo__Avail__7EF6D905]
GO
ALTER TABLE [Admins].[Country] DROP CONSTRAINT [DF__Country__Residen__4B422AD5]
GO
ALTER TABLE [Admins].[Country] DROP CONSTRAINT [DF__Country__IsResid__7E02B4CC]
GO
ALTER TABLE [Admins].[Country] DROP CONSTRAINT [DF__Country__IsCount__7D0E9093]
GO
ALTER TABLE [Admins].[Country] DROP CONSTRAINT [DF__Country__IsMinis__7C1A6C5A]
GO
ALTER TABLE [Admins].[Country] DROP CONSTRAINT [DF__Country__IsCourt__7B264821]
GO
ALTER TABLE [Admins].[Country] DROP CONSTRAINT [DF_Country_IsGcc]
GO
ALTER TABLE [Admins].[Continent] DROP CONSTRAINT [DF__Continent__ViewO__4DE98D56]
GO
ALTER TABLE [Admins].[City] DROP CONSTRAINT [DF__City__LookupType__0169315C]
GO
ALTER TABLE [Admins].[CampPackageCategory] DROP CONSTRAINT [DF__CampPacka__NewPa__1387E197]
GO
ALTER TABLE [Admins].[Camp] DROP CONSTRAINT [DF__Camp__MinistryQu__090A5324]
GO
ALTER TABLE [Admins].[Camp] DROP CONSTRAINT [DF__Camp__CourtesyQu__09FE775D]
GO
ALTER TABLE [Admins].[Camp] DROP CONSTRAINT [DF__Camp__PiligrimsQ__08162EEB]
GO
ALTER TABLE [Admins].[Camp] DROP CONSTRAINT [DF__Camp__Descriptio__1D7B6025]
GO
ALTER TABLE [Admins].[Camp] DROP CONSTRAINT [DF__Camp__Descriptio__1C873BEC]
GO
ALTER TABLE [Admins].[Camp] DROP CONSTRAINT [DF__Camp__B2CQuota__0AF29B96]
GO
ALTER TABLE [Admins].[Airport] DROP CONSTRAINT [DF__Airport__LookupT__025D5595]
GO
ALTER TABLE [Admins].[Airline] DROP CONSTRAINT [DF__Airline__LookupT__035179CE]
GO
/****** Object:  Table [Packages].[TransportationSpecialContractRoute]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[TransportationSpecialContractRoute]') AND type in (N'U'))
DROP TABLE [Packages].[TransportationSpecialContractRoute]
GO
/****** Object:  Table [Packages].[TransportationSpecialContract]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[TransportationSpecialContract]') AND type in (N'U'))
DROP TABLE [Packages].[TransportationSpecialContract]
GO
/****** Object:  Table [Packages].[ServiceProviderPhoto]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[ServiceProviderPhoto]') AND type in (N'U'))
DROP TABLE [Packages].[ServiceProviderPhoto]
GO
/****** Object:  Table [Packages].[ServiceProviderPackageCategory]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[ServiceProviderPackageCategory]') AND type in (N'U'))
DROP TABLE [Packages].[ServiceProviderPackageCategory]
GO
/****** Object:  Table [Packages].[ServiceProviderGroundCenter]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[ServiceProviderGroundCenter]') AND type in (N'U'))
DROP TABLE [Packages].[ServiceProviderGroundCenter]
GO
/****** Object:  Table [Packages].[ServiceProviderAdditionalServices]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[ServiceProviderAdditionalServices]') AND type in (N'U'))
DROP TABLE [Packages].[ServiceProviderAdditionalServices]
GO
/****** Object:  Table [Packages].[ServiceProvider]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[ServiceProvider]') AND type in (N'U'))
DROP TABLE [Packages].[ServiceProvider]
GO
/****** Object:  Table [Packages].[PricingStructure]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[PricingStructure]') AND type in (N'U'))
DROP TABLE [Packages].[PricingStructure]
GO
/****** Object:  Table [Packages].[PriceDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[PriceDetail]') AND type in (N'U'))
DROP TABLE [Packages].[PriceDetail]
GO
/****** Object:  Table [Packages].[PackageTransportationPath]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[PackageTransportationPath]') AND type in (N'U'))
DROP TABLE [Packages].[PackageTransportationPath]
GO
/****** Object:  Table [Packages].[PackageServiceProviderAdditionalService]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[PackageServiceProviderAdditionalService]') AND type in (N'U'))
DROP TABLE [Packages].[PackageServiceProviderAdditionalService]
GO
/****** Object:  Table [Packages].[PackagePhotos]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[PackagePhotos]') AND type in (N'U'))
DROP TABLE [Packages].[PackagePhotos]
GO
/****** Object:  Table [Packages].[PackageOperation]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[PackageOperation]') AND type in (N'U'))
DROP TABLE [Packages].[PackageOperation]
GO
/****** Object:  Table [Packages].[PackageHousingContractRoom]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[PackageHousingContractRoom]') AND type in (N'U'))
DROP TABLE [Packages].[PackageHousingContractRoom]
GO
/****** Object:  Table [Packages].[PackageHousingContract]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[PackageHousingContract]') AND type in (N'U'))
DROP TABLE [Packages].[PackageHousingContract]
GO
/****** Object:  Table [Packages].[PackageFoodContract]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[PackageFoodContract]') AND type in (N'U'))
DROP TABLE [Packages].[PackageFoodContract]
GO
/****** Object:  Table [Packages].[PackageFlightContract]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[PackageFlightContract]') AND type in (N'U'))
DROP TABLE [Packages].[PackageFlightContract]
GO
/****** Object:  Table [Packages].[Package]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[Package]') AND type in (N'U'))
DROP TABLE [Packages].[Package]
GO
/****** Object:  Table [Packages].[HousingContractRoom]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[HousingContractRoom]') AND type in (N'U'))
DROP TABLE [Packages].[HousingContractRoom]
GO
/****** Object:  Table [Packages].[HousingContractMeal]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[HousingContractMeal]') AND type in (N'U'))
DROP TABLE [Packages].[HousingContractMeal]
GO
/****** Object:  Table [Packages].[HousingContract]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[HousingContract]') AND type in (N'U'))
DROP TABLE [Packages].[HousingContract]
GO
/****** Object:  Table [Packages].[FoodContractMenu]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[FoodContractMenu]') AND type in (N'U'))
DROP TABLE [Packages].[FoodContractMenu]
GO
/****** Object:  Table [Packages].[FoodContract]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[FoodContract]') AND type in (N'U'))
DROP TABLE [Packages].[FoodContract]
GO
/****** Object:  Table [Packages].[FlightTrip]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[FlightTrip]') AND type in (N'U'))
DROP TABLE [Packages].[FlightTrip]
GO
/****** Object:  Table [Packages].[FlightRoute]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[FlightRoute]') AND type in (N'U'))
DROP TABLE [Packages].[FlightRoute]
GO
/****** Object:  Table [Packages].[FlightContractCountry]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[FlightContractCountry]') AND type in (N'U'))
DROP TABLE [Packages].[FlightContractCountry]
GO
/****** Object:  Table [Packages].[FlightContract]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Packages].[FlightContract]') AND type in (N'U'))
DROP TABLE [Packages].[FlightContract]
GO
/****** Object:  Table [Notifications].[RequestAction]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Notifications].[RequestAction]') AND type in (N'U'))
DROP TABLE [Notifications].[RequestAction]
GO
/****** Object:  Table [Notifications].[Notification]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Notifications].[Notification]') AND type in (N'U'))
DROP TABLE [Notifications].[Notification]
GO
/****** Object:  Table [MoneyFunds].[WalletTransactionDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MoneyFunds].[WalletTransactionDetail]') AND type in (N'U'))
DROP TABLE [MoneyFunds].[WalletTransactionDetail]
GO
/****** Object:  Table [MoneyFunds].[WalletTransaction]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MoneyFunds].[WalletTransaction]') AND type in (N'U'))
DROP TABLE [MoneyFunds].[WalletTransaction]
GO
/****** Object:  Table [MoneyFunds].[WalletRefundTransaction]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MoneyFunds].[WalletRefundTransaction]') AND type in (N'U'))
DROP TABLE [MoneyFunds].[WalletRefundTransaction]
GO
/****** Object:  Table [MoneyFunds].[WalletDiscount]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MoneyFunds].[WalletDiscount]') AND type in (N'U'))
DROP TABLE [MoneyFunds].[WalletDiscount]
GO
/****** Object:  Table [MoneyFunds].[Wallet]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MoneyFunds].[Wallet]') AND type in (N'U'))
DROP TABLE [MoneyFunds].[Wallet]
GO
/****** Object:  Table [MoneyFunds].[BillingAddress]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MoneyFunds].[BillingAddress]') AND type in (N'U'))
DROP TABLE [MoneyFunds].[BillingAddress]
GO
/****** Object:  Table [MoneyFunds].[BankDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MoneyFunds].[BankDetail]') AND type in (N'U'))
DROP TABLE [MoneyFunds].[BankDetail]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[__EFMigrationsHistory]') AND type in (N'U'))
DROP TABLE [dbo].[__EFMigrationsHistory]
GO
/****** Object:  Table [Applicants].[Application]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[Application]') AND type in (N'U'))
DROP TABLE [Applicants].[Application]
GO
/****** Object:  Table [Applicants].[ApplicantVisaAnswer]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantVisaAnswer]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantVisaAnswer]
GO
/****** Object:  Table [Applicants].[ApplicantTravelHistory]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantTravelHistory]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantTravelHistory]
GO
/****** Object:  Table [Applicants].[ApplicantRelativeResident]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantRelativeResident]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantRelativeResident]
GO
/****** Object:  Table [Applicants].[ApplicantRejectionReason]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantRejectionReason]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantRejectionReason]
GO
/****** Object:  Table [Applicants].[ApplicantPreference]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantPreference]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantPreference]
GO
/****** Object:  Table [Applicants].[ApplicantOtherNationality]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantOtherNationality]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantOtherNationality]
GO
/****** Object:  Table [Applicants].[ApplicantOccupationDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantOccupationDetail]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantOccupationDetail]
GO
/****** Object:  Table [Applicants].[ApplicantHistory]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantHistory]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantHistory]
GO
/****** Object:  Table [Applicants].[ApplicantFlightDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantFlightDetail]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantFlightDetail]
GO
/****** Object:  Table [Applicants].[ApplicantDocument]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantDocument]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantDocument]
GO
/****** Object:  Table [Applicants].[ApplicantDeleteReason]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantDeleteReason]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantDeleteReason]
GO
/****** Object:  Table [Applicants].[ApplicantContactDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantContactDetail]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantContactDetail]
GO
/****** Object:  Table [Applicants].[ApplicantBankDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantBankDetail]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantBankDetail]
GO
/****** Object:  Table [Applicants].[ApplicantArrivalDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantArrivalDetail]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantArrivalDetail]
GO
/****** Object:  Table [Applicants].[ApplicantAllergy]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[ApplicantAllergy]') AND type in (N'U'))
DROP TABLE [Applicants].[ApplicantAllergy]
GO
/****** Object:  Table [Applicants].[Applicant]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Applicants].[Applicant]') AND type in (N'U'))
DROP TABLE [Applicants].[Applicant]
GO
/****** Object:  Table [Admins].[WebVisitor]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[WebVisitor]') AND type in (N'U'))
DROP TABLE [Admins].[WebVisitor]
GO
/****** Object:  Table [Admins].[TransportationProvider]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[TransportationProvider]') AND type in (N'U'))
DROP TABLE [Admins].[TransportationProvider]
GO
/****** Object:  Table [Admins].[TransportationPath]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[TransportationPath]') AND type in (N'U'))
DROP TABLE [Admins].[TransportationPath]
GO
/****** Object:  Table [Admins].[TourGuideRegistrationPilgrimException]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[TourGuideRegistrationPilgrimException]') AND type in (N'U'))
DROP TABLE [Admins].[TourGuideRegistrationPilgrimException]
GO
/****** Object:  Table [Admins].[TourGuideRegistrationPeriodException]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[TourGuideRegistrationPeriodException]') AND type in (N'U'))
DROP TABLE [Admins].[TourGuideRegistrationPeriodException]
GO
/****** Object:  Table [Admins].[TourGuideRegistration]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[TourGuideRegistration]') AND type in (N'U'))
DROP TABLE [Admins].[TourGuideRegistration]
GO
/****** Object:  Table [Admins].[Terminal]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[Terminal]') AND type in (N'U'))
DROP TABLE [Admins].[Terminal]
GO
/****** Object:  Table [Admins].[TaskManager]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[TaskManager]') AND type in (N'U'))
DROP TABLE [Admins].[TaskManager]
GO
/****** Object:  Table [Admins].[SystemUser]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[SystemUser]') AND type in (N'U'))
DROP TABLE [Admins].[SystemUser]
GO
/****** Object:  Table [Admins].[SystemLanguage]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[SystemLanguage]') AND type in (N'U'))
DROP TABLE [Admins].[SystemLanguage]
GO
/****** Object:  Table [Admins].[ServiceCenterWorkHours]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[ServiceCenterWorkHours]') AND type in (N'U'))
DROP TABLE [Admins].[ServiceCenterWorkHours]
GO
/****** Object:  Table [Admins].[ServiceCenterAppointment]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[ServiceCenterAppointment]') AND type in (N'U'))
DROP TABLE [Admins].[ServiceCenterAppointment]
GO
/****** Object:  Table [Admins].[ServiceCenter]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[ServiceCenter]') AND type in (N'U'))
DROP TABLE [Admins].[ServiceCenter]
GO
/****** Object:  Table [Admins].[ReservationPeriodException]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[ReservationPeriodException]') AND type in (N'U'))
DROP TABLE [Admins].[ReservationPeriodException]
GO
/****** Object:  Table [Admins].[ReservationPeriod]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[ReservationPeriod]') AND type in (N'U'))
DROP TABLE [Admins].[ReservationPeriod]
GO
/****** Object:  Table [Admins].[RelativeRelation]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[RelativeRelation]') AND type in (N'U'))
DROP TABLE [Admins].[RelativeRelation]
GO
/****** Object:  Table [Admins].[RejectingReason]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[RejectingReason]') AND type in (N'U'))
DROP TABLE [Admins].[RejectingReason]
GO
/****** Object:  Table [Admins].[PaymentPeriod]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[PaymentPeriod]') AND type in (N'U'))
DROP TABLE [Admins].[PaymentPeriod]
GO
/****** Object:  Table [Admins].[PassportType]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[PassportType]') AND type in (N'U'))
DROP TABLE [Admins].[PassportType]
GO
/****** Object:  Table [Admins].[PackageCategory]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[PackageCategory]') AND type in (N'U'))
DROP TABLE [Admins].[PackageCategory]
GO
/****** Object:  Table [Admins].[LookupLocalization]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[LookupLocalization]') AND type in (N'U'))
DROP TABLE [Admins].[LookupLocalization]
GO
/****** Object:  Table [Admins].[LatestNews]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[LatestNews]') AND type in (N'U'))
DROP TABLE [Admins].[LatestNews]
GO
/****** Object:  Table [Admins].[HousingZone]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[HousingZone]') AND type in (N'U'))
DROP TABLE [Admins].[HousingZone]
GO
/****** Object:  Table [Admins].[HousingProviderService]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[HousingProviderService]') AND type in (N'U'))
DROP TABLE [Admins].[HousingProviderService]
GO
/****** Object:  Table [Admins].[HousingProviderRepresentativeContact]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[HousingProviderRepresentativeContact]') AND type in (N'U'))
DROP TABLE [Admins].[HousingProviderRepresentativeContact]
GO
/****** Object:  Table [Admins].[HousingProviderPhoto]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[HousingProviderPhoto]') AND type in (N'U'))
DROP TABLE [Admins].[HousingProviderPhoto]
GO
/****** Object:  Table [Admins].[HousingProvider]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[HousingProvider]') AND type in (N'U'))
DROP TABLE [Admins].[HousingProvider]
GO
/****** Object:  Table [Admins].[HajjEvent]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[HajjEvent]') AND type in (N'U'))
DROP TABLE [Admins].[HajjEvent]
GO
/****** Object:  Table [Admins].[GlobalQuotaSetting]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[GlobalQuotaSetting]') AND type in (N'U'))
DROP TABLE [Admins].[GlobalQuotaSetting]
GO
/****** Object:  Table [Admins].[Gender]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[Gender]') AND type in (N'U'))
DROP TABLE [Admins].[Gender]
GO
/****** Object:  Table [Admins].[FoodProvider]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[FoodProvider]') AND type in (N'U'))
DROP TABLE [Admins].[FoodProvider]
GO
/****** Object:  Table [Admins].[EmbassyQuota]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[EmbassyQuota]') AND type in (N'U'))
DROP TABLE [Admins].[EmbassyQuota]
GO
/****** Object:  Table [Admins].[Embassy]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[Embassy]') AND type in (N'U'))
DROP TABLE [Admins].[Embassy]
GO
/****** Object:  Table [Admins].[DocumentType]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[DocumentType]') AND type in (N'U'))
DROP TABLE [Admins].[DocumentType]
GO
/****** Object:  Table [Admins].[DeleteReason]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[DeleteReason]') AND type in (N'U'))
DROP TABLE [Admins].[DeleteReason]
GO
/****** Object:  Table [Admins].[CountryNote]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[CountryNote]') AND type in (N'U'))
DROP TABLE [Admins].[CountryNote]
GO
/****** Object:  Table [Admins].[CountryHistory]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[CountryHistory]') AND type in (N'U'))
DROP TABLE [Admins].[CountryHistory]
GO
/****** Object:  Table [Admins].[CountryGroup]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[CountryGroup]') AND type in (N'U'))
DROP TABLE [Admins].[CountryGroup]
GO
/****** Object:  Table [Admins].[CountryAllowedAge]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[CountryAllowedAge]') AND type in (N'U'))
DROP TABLE [Admins].[CountryAllowedAge]
GO
/****** Object:  Table [Admins].[Country]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[Country]') AND type in (N'U'))
DROP TABLE [Admins].[Country]
GO
/****** Object:  Table [Admins].[Continent]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[Continent]') AND type in (N'U'))
DROP TABLE [Admins].[Continent]
GO
/****** Object:  Table [Admins].[City]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[City]') AND type in (N'U'))
DROP TABLE [Admins].[City]
GO
/****** Object:  Table [Admins].[CampTransportation]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[CampTransportation]') AND type in (N'U'))
DROP TABLE [Admins].[CampTransportation]
GO
/****** Object:  Table [Admins].[CampPackageCategory]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[CampPackageCategory]') AND type in (N'U'))
DROP TABLE [Admins].[CampPackageCategory]
GO
/****** Object:  Table [Admins].[CampMedia]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[CampMedia]') AND type in (N'U'))
DROP TABLE [Admins].[CampMedia]
GO
/****** Object:  Table [Admins].[Camp]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[Camp]') AND type in (N'U'))
DROP TABLE [Admins].[Camp]
GO
/****** Object:  Table [Admins].[Airport]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[Airport]') AND type in (N'U'))
DROP TABLE [Admins].[Airport]
GO
/****** Object:  Table [Admins].[Airline]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[Airline]') AND type in (N'U'))
DROP TABLE [Admins].[Airline]
GO
/****** Object:  Table [Admins].[AdditionalServiceType]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[AdditionalServiceType]') AND type in (N'U'))
DROP TABLE [Admins].[AdditionalServiceType]
GO
/****** Object:  Table [Admins].[AdditionalService]    Script Date: 04/01/2024 2:18:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Admins].[AdditionalService]') AND type in (N'U'))
DROP TABLE [Admins].[AdditionalService]
GO
/****** Object:  Table [Admins].[AdditionalService]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[AdditionalService](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NULL,
	[NameEn] [varchar](250) NOT NULL,
	[NameAr] [nvarchar](250) NULL,
	[AdditionalServiceTypeId] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_AdditionalService] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[AdditionalServiceType]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[AdditionalServiceType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NULL,
	[NameEn] [varchar](250) NOT NULL,
	[NameAr] [nvarchar](250) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[IconPath] [nvarchar](250) NULL,
 CONSTRAINT [PK_AdditionalServiceType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[Airline]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[Airline](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NameAr] [nvarchar](50) NOT NULL,
	[NameEn] [varchar](50) NOT NULL,
	[Code] [varchar](20) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[LookupType] [int] NOT NULL,
 CONSTRAINT [PK_Airline] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[Airport]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[Airport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NameAr] [nvarchar](50) NOT NULL,
	[NameEn] [varchar](50) NOT NULL,
	[Code] [varchar](20) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[LookupType] [int] NOT NULL,
 CONSTRAINT [PK_Airport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[Camp]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[Camp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NameEN] [nvarchar](50) NOT NULL,
	[NameAR] [nvarchar](50) NOT NULL,
	[B2CQuota] [int] NOT NULL,
	[UsedB2CQuota] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[DescriptionAR] [nvarchar](200) NOT NULL,
	[DescriptionEN] [nvarchar](200) NOT NULL,
	[PiligrimsQuota] [int] NOT NULL,
	[Location] [varchar](2000) NULL,
	[CourtesyQuota] [int] NOT NULL,
	[MinistryQuota] [int] NOT NULL,
 CONSTRAINT [PK_Camp] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[CampMedia]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[CampMedia](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CampId] [int] NOT NULL,
	[MediaId] [varchar](2500) NOT NULL,
	[MediaUrl] [varchar](2500) NOT NULL,
	[MediaType] [smallint] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_CampMedia] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[CampPackageCategory]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[CampPackageCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CampId] [int] NOT NULL,
	[QuotaType] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[PackageCategoryId] [int] NOT NULL,
 CONSTRAINT [PK_CampPackageCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[CampTransportation]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[CampTransportation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TransportationDescription] [nvarchar](2500) NULL,
	[CampId] [int] NOT NULL,
	[SystemLanguageId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_CampTransportation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[City]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[City](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Code] [varchar](20) NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[LookupType] [int] NOT NULL,
 CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[Continent]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[Continent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[ViewOrder] [int] NOT NULL,
 CONSTRAINT [PK_Continent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[Country]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[Country](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Capital] [varchar](50) NOT NULL,
	[Nationality] [varchar](50) NOT NULL,
	[NationalityCode] [varchar](20) NOT NULL,
	[IsoCode2] [varchar](2) NOT NULL,
	[IsoCode3] [varchar](3) NOT NULL,
	[CurrencyCode] [varchar](5) NOT NULL,
	[CurrencyName] [nvarchar](50) NOT NULL,
	[DialCode] [varchar](20) NOT NULL,
	[Code] [varchar](20) NULL,
	[EligibleForHajj] [bit] NOT NULL,
	[GroupCount] [int] NOT NULL,
	[CountryQouta] [int] NOT NULL,
	[ResidentsQouta] [int] NOT NULL,
	[IsArab] [bit] NOT NULL,
	[IsGcc] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsNationalityRestricted] [bit] NOT NULL,
	[EnableCachPayment] [bit] NOT NULL,
	[LocalBankAccountConfig] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[ContinentId] [int] NULL,
	[IsCourtesyQuotaCheckEnabled] [bit] NOT NULL,
	[IsMinistryQuotaCheckEnabled] [bit] NOT NULL,
	[IsCountryQoutaCheckEnabled] [bit] NOT NULL,
	[IsResidentsQoutaCheckEnabled] [bit] NOT NULL,
	[ResidentsQoutaRatio] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[CountryAllowedAge]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[CountryAllowedAge](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NULL,
	[AgeFrom] [int] NOT NULL,
	[AgeTo] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_CountryAllowedAge] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[CountryGroup]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[CountryGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GroupNumber] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_CountryGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[CountryHistory]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[CountryHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NOT NULL,
	[CountryQouta] [int] NULL,
	[ResidentsQouta] [int] NULL,
	[IsActive] [bit] NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_CountryHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[CountryNote]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[CountryNote](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Note] [varchar](2500) NOT NULL,
	[CountryId] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_CountryNote] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[DeleteReason]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[DeleteReason](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](2500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_DeleteReason] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[DocumentType]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[DocumentType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](250) NOT NULL,
	[Code] [varchar](20) NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_DocumentType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[Embassy]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[Embassy](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Code] [varchar](20) NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Embassy] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[EmbassyQuota]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[EmbassyQuota](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmbassyId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
	[Value] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_EmbassyQuota] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[FoodProvider]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[FoodProvider](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NULL,
	[NameEn] [varchar](250) NOT NULL,
	[NameAr] [nvarchar](250) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_FoodProvider] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[Gender]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[Gender](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Code] [varchar](20) NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Gender] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[GlobalQuotaSetting]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[GlobalQuotaSetting](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[B2CGlobalQuota] [int] NOT NULL,
	[MinistryGlobalQuota] [int] NOT NULL,
	[CourtesyGlobalQuota] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[AvailableB2CGlobalQuota] [int] NOT NULL,
	[AvailableCourtesyGlobalQuota] [int] NOT NULL,
	[AvailableMinistryGlobalQuota] [int] NOT NULL,
	[IsB2CQuotaEnabled] [bit] NOT NULL,
	[IsCourtesyQuotaEnabled] [bit] NOT NULL,
	[IsMinistryQuotaEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_GlobalQuotaSetting] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[HajjEvent]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[HajjEvent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](100) NOT NULL,
	[Description] [varchar](2500) NOT NULL,
	[EventDate] [datetime2](7) NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_HajjEvent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[HousingProvider]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[HousingProvider](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NULL,
	[NameEn] [varchar](500) NOT NULL,
	[NameAr] [nvarchar](500) NULL,
	[CityId] [int] NOT NULL,
	[Rating] [int] NOT NULL,
	[Address] [nvarchar](500) NULL,
	[LocationLongitude] [nvarchar](20) NULL,
	[LocationLatitude] [nvarchar](20) NULL,
	[CommercialRegistrationNo] [varchar](20) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[DescriptionAr] [nvarchar](4000) NULL,
	[DescriptionEn] [varchar](4000) NOT NULL,
	[HousingZoneId] [int] NULL,
	[BookingClassification] [decimal](5, 2) NOT NULL,
	[BookingRate] [decimal](5, 2) NOT NULL,
	[TripAdvisorClassification] [decimal](5, 2) NOT NULL,
	[TripAdvisorRate] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_HousingProvider] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[HousingProviderPhoto]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[HousingProviderPhoto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HousingProviderId] [int] NOT NULL,
	[Url] [nvarchar](250) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_HousingProviderPhoto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[HousingProviderRepresentativeContact]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[HousingProviderRepresentativeContact](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HousingProviderId] [int] NOT NULL,
	[NameAr] [nvarchar](200) NOT NULL,
	[NameEn] [varchar](200) NOT NULL,
	[PhoneNumber] [varchar](20) NOT NULL,
	[Email] [varchar](200) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_HousingProviderRepresentativeContact] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[HousingProviderService]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[HousingProviderService](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HousingProviderId] [int] NOT NULL,
	[ServiceAr] [nvarchar](250) NULL,
	[ServiceEn] [varchar](250) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_HousingProviderService] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[HousingZone]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[HousingZone](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NameEn] [varchar](500) NOT NULL,
	[NameAr] [nvarchar](500) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[Code] [varchar](20) NULL,
 CONSTRAINT [PK_HousingZone] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[LatestNews]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[LatestNews](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_LatestNews] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[LookupLocalization]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[LookupLocalization](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](2500) NULL,
	[LookupId] [uniqueidentifier] NOT NULL,
	[SystemLanguageId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_LookupLocalization] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[PackageCategory]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[PackageCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[QuotaType] [int] NOT NULL,
	[IsMadinahRequired] [bit] NOT NULL,
	[IsTourGuideRequired] [bit] NOT NULL,
	[PackageHousingType] [smallint] NOT NULL,
	[RatingFrom] [int] NOT NULL,
	[RatingTo] [int] NOT NULL,
	[HousingZoneId] [int] NULL,
 CONSTRAINT [PK_PackageCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[PassportType]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[PassportType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Code] [varchar](20) NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_PassportType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[PaymentPeriod]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[PaymentPeriod](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PaymentTypeId] [int] NOT NULL,
	[AllowedDays] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_PaymentPeriod] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[RejectingReason]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[RejectingReason](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](2500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_RejectingReason] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[RelativeRelation]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[RelativeRelation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IsValidMahram] [bit] NULL,
	[Code] [varchar](20) NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_RelativeRelation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[ReservationPeriod]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[ReservationPeriod](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StartDay] [date] NOT NULL,
	[EndDay] [date] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ReservationPeriod] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[ReservationPeriodException]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[ReservationPeriodException](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReservationPeriodId] [int] NOT NULL,
	[ServiceProviderId] [uniqueidentifier] NOT NULL,
	[CountryId] [int] NULL,
	[ExceptionLevel] [int] NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ReservationPeriodException] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[ServiceCenter]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[ServiceCenter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[City] [nvarchar](500) NOT NULL,
	[Address] [nvarchar](1000) NOT NULL,
	[Mobile] [varchar](20) NOT NULL,
	[Telephone] [varchar](20) NOT NULL,
	[MapUrl] [nvarchar](1000) NULL,
	[CountryId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[EnableCachPayment] [bit] NOT NULL,
	[IsAgent] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[IsHelpAndSupportCenter] [bit] NOT NULL,
	[NumberOfAppointmentsPerHour] [int] NULL,
 CONSTRAINT [PK_ServiceCenter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[ServiceCenterAppointment]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[ServiceCenterAppointment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceCenterId] [int] NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[Email] [varchar](150) NOT NULL,
	[MobileNumber] [varchar](150) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Time] [time](7) NOT NULL,
 CONSTRAINT [PK_ServiceCenterAppointment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[ServiceCenterWorkHours]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[ServiceCenterWorkHours](
	[ServiceCenterId] [int] NOT NULL,
	[DayOfWeek] [int] NOT NULL,
	[OpeningTime] [time](7) NULL,
	[ClosingTime] [time](7) NULL,
	[IsOpen] [bit] NOT NULL,
 CONSTRAINT [PK_ServiceCenterWorkHours] PRIMARY KEY CLUSTERED 
(
	[ServiceCenterId] ASC,
	[DayOfWeek] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[SystemLanguage]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[SystemLanguage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[IsoCode] [varchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_SystemLanguage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[SystemUser]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[SystemUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdentityUserId] [uniqueidentifier] NOT NULL,
	[Email] [varchar](150) NOT NULL,
	[OtpValue] [int] NULL,
	[OtpExpiryDate] [datetime2](7) NULL,
	[IsActive] [bit] NOT NULL,
	[IsVerified] [bit] NOT NULL,
	[EntityId] [uniqueidentifier] NULL,
	[TempCode] [varchar](200) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[ServiceProviderId] [int] NULL,
	[UserCategory] [int] NULL,
 CONSTRAINT [PK_SystemUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[TaskManager]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[TaskManager](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[RunningCycles] [smallint] NOT NULL,
	[CurrentCycle] [smallint] NOT NULL,
	[RecurrenceEvery] [varchar](12) NOT NULL,
	[NextExecution] [datetime2](7) NULL,
	[LastRun] [datetime2](7) NULL,
	[ExecutionStatus] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[IsRunning] [bit] NOT NULL,
	[ExtraData] [varchar](max) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_TaskManager] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admins].[Terminal]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[Terminal](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NameAr] [nvarchar](50) NOT NULL,
	[NameEn] [varchar](50) NOT NULL,
	[Code] [varchar](20) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Terminal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[TourGuideRegistration]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[TourGuideRegistration](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EndDay] [date] NOT NULL,
	[PilgrimsCount] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[MinPilgrimsCount] [int] NOT NULL,
 CONSTRAINT [PK_TourGuideRegistration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[TourGuideRegistrationPeriodException]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[TourGuideRegistrationPeriodException](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TourGuideRegistrationId] [int] NOT NULL,
	[ServiceProviderId] [uniqueidentifier] NOT NULL,
	[EndDay] [date] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_TourGuideRegistrationPeriodException] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[TourGuideRegistrationPilgrimException]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[TourGuideRegistrationPilgrimException](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TourGuideRegistrationId] [int] NOT NULL,
	[ServiceProviderId] [uniqueidentifier] NOT NULL,
	[PilgrimsCount] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_TourGuideRegistrationPilgrimException] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[TransportationPath]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[TransportationPath](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NULL,
	[NameEn] [varchar](250) NOT NULL,
	[NameAr] [nvarchar](250) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[PriceWithoutVat] [money] NOT NULL,
	[TotalPrice] [money] NOT NULL,
 CONSTRAINT [PK_TransportationPath] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[TransportationProvider]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[TransportationProvider](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NULL,
	[NameEn] [varchar](500) NOT NULL,
	[NameAr] [nvarchar](500) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_TransportationProvider] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admins].[WebVisitor]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admins].[WebVisitor](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IpAddress] [varchar](50) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_WebVisitor] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[Applicant]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[Applicant](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationId] [int] NOT NULL,
	[ApplicantStatus] [int] NOT NULL,
	[CourtesyType] [int] NOT NULL,
	[ApplicantType] [int] NOT NULL,
	[CountryResidenceId] [uniqueidentifier] NOT NULL,
	[Email] [varchar](150) NOT NULL,
	[NotificationLanguageId] [uniqueidentifier] NOT NULL,
	[NationalityId] [uniqueidentifier] NULL,
	[GenderId] [uniqueidentifier] NULL,
	[EmbassyId] [uniqueidentifier] NULL,
	[EntryTypeId] [int] NULL,
	[RelativeRelationId] [uniqueidentifier] NULL,
	[MobileNumber] [varchar](150) NULL,
	[BirthDate] [datetime2](7) NULL,
	[FirstNameEn] [varchar](150) NULL,
	[SecondNameEn] [varchar](150) NULL,
	[MiddleNameEn] [varchar](150) NULL,
	[LastNameEn] [varchar](150) NULL,
	[FirstNameAr] [nvarchar](150) NULL,
	[SecondNameAr] [nvarchar](150) NULL,
	[MiddleNameAr] [nvarchar](150) NULL,
	[LastNameAr] [nvarchar](150) NULL,
	[PassportTypeId] [uniqueidentifier] NULL,
	[PassportNumber] [varchar](150) NULL,
	[IssueDate] [datetime2](7) NULL,
	[ExpiryDate] [datetime2](7) NULL,
	[BirthPlace] [nvarchar](50) NULL,
	[IssuePlace] [nvarchar](50) NULL,
	[ResidenceIdNumber] [varchar](150) NULL,
	[ResidenceIdIssueDate] [datetime2](7) NULL,
	[ResidenceIdExpiryDate] [datetime2](7) NULL,
	[VisaStatus] [int] NULL,
	[MofaApplicationNumber] [varchar](20) NULL,
	[MofaVisaNumber] [varchar](20) NULL,
	[FlightBookingNumber] [varchar](50) NULL,
	[AgencyId] [bigint] NULL,
	[SubAgencyId] [bigint] NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[IsMain] [bit] NOT NULL,
	[MaritalStatusId] [int] NULL,
 CONSTRAINT [PK_Applicant] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantAllergy]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantAllergy](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[AllergyTypeId] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantAllergy] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantArrivalDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantArrivalDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[ExpectedEntryDate] [datetime2](7) NOT NULL,
	[ExpectedDaysInKingdom] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[TravelIdentifier] [varchar](20) NULL,
 CONSTRAINT [PK_ApplicantArrivalDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantBankDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantBankDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[AccountType] [int] NOT NULL,
	[AccountNumber] [varchar](50) NOT NULL,
	[ClearingCode] [varchar](15) NULL,
	[BankName] [nvarchar](60) NULL,
	[BankAddress] [nvarchar](60) NULL,
	[BankSwiftCode] [varchar](15) NULL,
	[CountryId] [uniqueidentifier] NOT NULL,
	[State] [nvarchar](50) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[PostalCode] [nvarchar](10) NOT NULL,
	[FirstAddress] [nvarchar](250) NOT NULL,
	[SecondAddress] [nvarchar](250) NULL,
	[ThirdAddress] [nvarchar](250) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantBankDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantContactDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantContactDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[MobileContactNumber] [varchar](150) NOT NULL,
	[SaudiMobileNumber] [varchar](150) NULL,
	[EmergencyContactFullName] [varchar](150) NULL,
	[EmergencyContactNumber] [varchar](150) NULL,
	[HomeAddress] [varchar](300) NOT NULL,
	[PostalCode] [varchar](15) NULL,
	[POBox] [varchar](15) NULL,
	[StreetAddress] [varchar](150) NOT NULL,
	[AppartmentHouseNumber] [varchar](150) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantContactDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantDeleteReason]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantDeleteReason](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeleteReasonId] [uniqueidentifier] NOT NULL,
	[ApplicantEmail] [varchar](150) NOT NULL,
	[CountryResidenceId] [uniqueidentifier] NOT NULL,
	[NationalityId] [uniqueidentifier] NULL,
	[FirstNameEn] [varchar](150) NULL,
	[LastNameEn] [varchar](150) NULL,
	[NotificationLanguageId] [uniqueidentifier] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ApplicantDeleteReason] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantDocument]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantDocument](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[DocumentId] [uniqueidentifier] NOT NULL,
	[FilePath] [nvarchar](500) NOT NULL,
	[FileName] [nvarchar](50) NOT NULL,
	[MimeType] [nvarchar](100) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantDocument] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantFlightDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantFlightDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[FlightNumber] [varchar](15) NULL,
	[AirlineName] [nvarchar](50) NULL,
	[DepartureDateTime] [datetime2](7) NULL,
	[ArrivalDateTime] [datetime2](7) NULL,
	[ArrivalCity] [nvarchar](50) NULL,
	[AirportName] [nvarchar](50) NULL,
	[TerminalNumber] [int] NULL,
	[MakkahHotelName] [nvarchar](100) NULL,
	[MakkahHotelAddress] [nvarchar](100) NULL,
	[MadinahHotelName] [nvarchar](100) NULL,
	[MadinahHotelAddress] [nvarchar](100) NULL,
	[JeddahHotelName] [nvarchar](100) NULL,
	[JeddahHotelAddress] [nvarchar](100) NULL,
	[MobileNumber] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantFlightDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantHistory]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Note] [nvarchar](500) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantOccupationDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantOccupationDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[Occupation] [varchar](150) NOT NULL,
	[CurrentEmployer] [varchar](150) NOT NULL,
	[PreviousWork] [varchar](150) NOT NULL,
	[NameOfSector] [varchar](150) NOT NULL,
	[WorkContactNumber] [varchar](150) NULL,
	[CanOfferMedicalSupport] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantOccupationDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantOtherNationality]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantOtherNationality](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[NationalityId] [uniqueidentifier] NOT NULL,
	[AcquisitionDate] [datetime2](7) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantOtherNationality] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantPreference]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantPreference](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[WheelChairAccessible] [bit] NOT NULL,
	[BrailleMaterials] [bit] NOT NULL,
	[SignLanguageInterpreters] [bit] NOT NULL,
	[OtherAccessibility] [bit] NOT NULL,
	[OtherAccessibilityDescription] [nvarchar](250) NULL,
	[Diabetes] [bit] NOT NULL,
	[HighBloodPressure] [bit] NOT NULL,
	[HeartDisease] [bit] NOT NULL,
	[OtherHealthCondition] [bit] NOT NULL,
	[OtherHealthConditionDescription] [nvarchar](250) NULL,
	[Vegetarian] [bit] NOT NULL,
	[Pescatarian] [bit] NOT NULL,
	[Vegan] [bit] NOT NULL,
	[FoodAllergies] [bit] NOT NULL,
	[OtherDietary] [bit] NOT NULL,
	[OtherDietaryDescription] [nvarchar](250) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[Asthma] [bit] NOT NULL,
 CONSTRAINT [PK_ApplicantPreference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantRejectionReason]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantRejectionReason](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantHistoryId] [int] NOT NULL,
	[RejectingReasonId] [uniqueidentifier] NOT NULL,
	[Note] [nvarchar](500) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantRejectionReason] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantRelativeResident]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantRelativeResident](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[RelativeRelationId] [uniqueidentifier] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantRelativeResident] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantTravelHistory]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantTravelHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[CountryId] [uniqueidentifier] NOT NULL,
	[Reason] [nvarchar](100) NULL,
	[FromDate] [datetime2](7) NOT NULL,
	[ToDate] [datetime2](7) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantTravelHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[ApplicantVisaAnswer]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[ApplicantVisaAnswer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[PreviouslyReceivedKSAVisa] [bit] NULL,
	[PreviouslyReceivedKSAVisaAnswer] [nvarchar](100) NULL,
	[PreviousKSAVisaRejection] [bit] NULL,
	[PreviousKSAVisaRejectionAnswer] [nvarchar](100) NULL,
	[HaveRelativesResigingInKSA] [bit] NULL,
	[PassportHasRestrictionForOneTrip] [bit] NULL,
	[PassportHasRestrictionForOneTripAnswer] [nvarchar](100) NULL,
	[HoldOtherNationalities] [bit] NULL,
	[TraveledToOtherCountries] [bit] NULL,
	[RequiredVaccinationsBeenTaken] [bit] NULL,
	[RequiredVaccinationsBeenTakenAnswer] [nvarchar](100) NULL,
	[HaveAnyPhysicalDisability] [bit] NULL,
	[HaveAnyPhysicalDisabilityAnswer] [nvarchar](100) NULL,
	[DeportedFromAnyCountryBefore] [bit] NULL,
	[DeportedFromAnyCountryBeforeAnswer] [nvarchar](100) NULL,
	[WorkedInMediaOrPolitics] [bit] NULL,
	[WorkedInMediaOrPoliticsAnswer] [nvarchar](100) NULL,
	[ServedInArmedOrSecurityForces] [bit] NULL,
	[ServedInArmedOrSecurityForcesAnswer] [nvarchar](100) NULL,
	[SentencedToPrisonBefore] [bit] NULL,
	[SentencedToPrisonBeforeAnswer] [nvarchar](100) NULL,
	[ArrestedOrConvictedForTerrorismBefore] [bit] NULL,
	[ArrestedOrConvictedForTerrorismBeforeAnswer] [nvarchar](100) NULL,
	[ConvictedInSmugglingMoneyLaundering] [bit] NULL,
	[ConvictedInSmugglingMoneyLaunderingAnswer] [nvarchar](100) NULL,
	[BelongedToTerroristOrganizationBefore] [bit] NULL,
	[BelongedToTerroristOrganizationBeforeAnswer] [nvarchar](100) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ApplicantVisaAnswer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Applicants].[Application]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applicants].[Application](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Year] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[PreferredPackageCategoryId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [MoneyFunds].[BankDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MoneyFunds].[BankDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WalletId] [int] NOT NULL,
	[AccountType] [int] NOT NULL,
	[AccountNumber] [varchar](50) NOT NULL,
	[ClearingCode] [varchar](15) NULL,
	[Name] [nvarchar](60) NULL,
	[Address] [nvarchar](60) NULL,
	[SwiftCode] [varchar](15) NULL,
	[CountryId] [uniqueidentifier] NOT NULL,
	[State] [nvarchar](50) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[PostalCode] [nvarchar](10) NOT NULL,
	[FirstAddress] [nvarchar](250) NOT NULL,
	[SecondAddress] [nvarchar](250) NULL,
	[ThirdAddress] [nvarchar](250) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_BankDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [MoneyFunds].[BillingAddress]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MoneyFunds].[BillingAddress](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WalletId] [int] NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[CountryId] [uniqueidentifier] NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[State] [nvarchar](50) NOT NULL,
	[PostalCode] [nvarchar](10) NOT NULL,
	[FirstAddress] [nvarchar](250) NOT NULL,
	[SecondAddress] [nvarchar](250) NULL,
	[ThirdAddress] [nvarchar](250) NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_BillingAddress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [MoneyFunds].[Wallet]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MoneyFunds].[Wallet](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WalletAgentTypeId] [int] NOT NULL,
	[AccountOwnerId] [uniqueidentifier] NOT NULL,
	[AccountIBAN] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Wallet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [MoneyFunds].[WalletDiscount]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MoneyFunds].[WalletDiscount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WalletId] [int] NOT NULL,
	[DiscountAmount] [money] NOT NULL,
	[IsUsed] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_WalletDiscount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [MoneyFunds].[WalletRefundTransaction]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MoneyFunds].[WalletRefundTransaction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WalletTransactionId] [int] NOT NULL,
	[WalletReferenceTransactionId] [int] NULL,
	[ApprovalStatusId] [int] NOT NULL,
	[IsProcessed] [bit] NOT NULL,
	[Amount] [money] NOT NULL,
	[VAT] [money] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_WalletRefundTransaction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [MoneyFunds].[WalletTransaction]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MoneyFunds].[WalletTransaction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WalletId] [int] NOT NULL,
	[TransactionSourceId] [int] NOT NULL,
	[TransactionTypeId] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_WalletTransaction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [MoneyFunds].[WalletTransactionDetail]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MoneyFunds].[WalletTransactionDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WalletTransactionId] [int] NOT NULL,
	[PaymentMethodTypeId] [int] NOT NULL,
	[WalletId] [int] NULL,
	[ServiceCenterId] [uniqueidentifier] NULL,
	[BankInwardReferenceNumber] [varchar](50) NULL,
	[BankRequestId] [varchar](50) NULL,
	[BankTransactionReferenceNumber] [varchar](50) NULL,
	[BankDebitAccountNumber] [varchar](50) NULL,
	[BankSenderReference] [varchar](16) NULL,
	[MerchantTransactionId] [uniqueidentifier] NULL,
	[PaymentReceiptNumber] [varchar](50) NULL,
	[CheckoutNumber] [varchar](50) NULL,
	[CardLast4Digits] [varchar](4) NULL,
	[SadadInvoiceNumber] [varchar](50) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_WalletTransactionDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Notifications].[Notification]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Notifications].[Notification](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RecipientId] [uniqueidentifier] NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[Status] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[Channel] [int] NOT NULL,
	[RemindMeLater] [bit] NOT NULL,
	[RecurrenceEvery] [varchar](12) NULL,
	[LastReminderWasAt] [datetime2](7) NULL,
	[ActionRequired] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Notification] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Notifications].[RequestAction]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Notifications].[RequestAction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NotificationId] [int] NOT NULL,
	[SenderId] [uniqueidentifier] NOT NULL,
	[Status] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[ActionResult] [nvarchar](250) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_RequestAction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[FlightContract]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[FlightContract](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceProviderId] [int] NULL,
	[FlightType] [smallint] NOT NULL,
	[ArrivalTripId] [int] NOT NULL,
	[ReturnTripId] [int] NOT NULL,
	[Name] [nvarchar](250) NULL,
	[Capacity] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[PriceDetailId] [int] NOT NULL,
	[IATANumber] [nvarchar](50) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[CapacityUsed] [int] NOT NULL,
	[RowVersion] [timestamp] NULL,
 CONSTRAINT [PK_FlightContract] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[FlightContractCountry]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[FlightContractCountry](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FlightContractId] [int] NOT NULL,
	[CountryId] [uniqueidentifier] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_FlightContractCountry] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[FlightRoute]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[FlightRoute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FlightTripId] [int] NOT NULL,
	[RouteIndex] [int] NOT NULL,
	[AirlineId] [uniqueidentifier] NOT NULL,
	[DurationInMinutes] [int] NULL,
	[FlightNumber] [nvarchar](50) NOT NULL,
	[DepartureDate] [datetime2](7) NOT NULL,
	[DepartureTime] [time](7) NOT NULL,
	[DepartureCityId] [uniqueidentifier] NOT NULL,
	[DepartureAirportId] [uniqueidentifier] NOT NULL,
	[ArrivalDate] [datetime2](7) NOT NULL,
	[ArrivalTime] [time](7) NOT NULL,
	[ArrivalCityId] [uniqueidentifier] NOT NULL,
	[ArrivalAirportId] [uniqueidentifier] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[ArrivalTerminal] [nvarchar](100) NOT NULL,
	[DepartureTerminal] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_FlightRoute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[FlightTrip]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[FlightTrip](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OriginCityId] [uniqueidentifier] NOT NULL,
	[DestinationCityId] [uniqueidentifier] NOT NULL,
	[DurationInMinutes] [int] NULL,
	[DirectFlight] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_FlightTrip] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[FoodContract]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[FoodContract](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ContractId] [bigint] NOT NULL,
	[ServiceProviderId] [int] NOT NULL,
	[FoodProviderId] [uniqueidentifier] NOT NULL,
	[CityId] [uniqueidentifier] NOT NULL,
	[Capacity] [int] NOT NULL,
	[TotalPrice] [money] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
	[PriceWithoutVAT] [money] NOT NULL,
	[MealType] [int] NOT NULL,
 CONSTRAINT [PK_FoodContract] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[FoodContractMenu]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[FoodContractMenu](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DescriptionAr] [nvarchar](4000) NULL,
	[DescriptionEn] [varchar](4000) NULL,
	[FoodContractId] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[MenuNameAr] [nvarchar](2500) NULL,
	[MenuNameEn] [varchar](2500) NULL,
 CONSTRAINT [PK_FoodContractMenu] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[HousingContract]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[HousingContract](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ContractId] [bigint] NOT NULL,
	[ServiceProviderId] [int] NOT NULL,
	[HousingProviderId] [uniqueidentifier] NOT NULL,
	[CityId] [uniqueidentifier] NOT NULL,
	[Capacity] [int] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NOT NULL,
	[IncludeCateringServices] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[HousePhoneNumber] [varchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[PriceWithoutVat] [money] NOT NULL,
	[TotalPrice] [money] NOT NULL,
 CONSTRAINT [PK_HousingContract] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[HousingContractMeal]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[HousingContractMeal](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HousingContractId] [int] NOT NULL,
	[MenuType] [int] NOT NULL,
	[DescriptionAr] [nvarchar](4000) NULL,
	[DescriptionEn] [varchar](4000) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_HousingContractMeal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[HousingContractRoom]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[HousingContractRoom](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoomType] [int] NOT NULL,
	[NumberOfRooms] [int] NOT NULL,
	[HousingContractId] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_HousingContractRoom] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[Package]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[Package](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageCategoryId] [uniqueidentifier] NOT NULL,
	[Stauts] [smallint] NOT NULL,
	[AvailabilityStatus] [smallint] NOT NULL,
	[ServiceProviderId] [int] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NOT NULL,
	[Capacity] [int] NOT NULL,
	[CapacityUsed] [int] NOT NULL,
	[TourGuideCapacity] [int] NOT NULL,
	[ApplicantsPerTourGuide] [int] NOT NULL,
	[NameAr] [nvarchar](250) NOT NULL,
	[NameEn] [varchar](250) NOT NULL,
	[DescriptionAr] [nvarchar](4000) NOT NULL,
	[DescriptionEn] [varchar](4000) NOT NULL,
	[CampId] [uniqueidentifier] NULL,
	[Price] [money] NOT NULL,
	[Vat] [money] NOT NULL,
	[TotalPrice] [money] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[QuotaType] [int] NOT NULL,
	[MadinahGroundCenterId] [int] NULL,
	[MakkahGroundCenterId] [int] NOT NULL,
	[ImageUrl] [nvarchar](max) NULL,
	[ImageUuid] [uniqueidentifier] NULL,
	[RowVersion] [timestamp] NULL,
 CONSTRAINT [PK_Package] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Packages].[PackageFlightContract]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[PackageFlightContract](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageId] [int] NOT NULL,
	[FlightContractId] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_PackageFlightContract] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[PackageFoodContract]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[PackageFoodContract](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageId] [int] NOT NULL,
	[FoodContractId] [int] NOT NULL,
	[Capacity] [int] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NOT NULL,
	[Type] [smallint] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[PriceDetailId] [int] NOT NULL,
 CONSTRAINT [PK_PackageFoodContract] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[PackageHousingContract]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[PackageHousingContract](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageId] [int] NOT NULL,
	[HousingContractId] [int] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NOT NULL,
	[Type] [smallint] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_PackageHousingContract] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[PackageHousingContractRoom]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[PackageHousingContractRoom](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageHousingContractId] [int] NOT NULL,
	[RoomType] [int] NOT NULL,
	[NumberOfRooms] [int] NOT NULL,
	[Capacity] [int] NOT NULL,
	[CapacityUsed] [int] NOT NULL,
	[TourGuideCapacity] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[PriceDetailId] [int] NOT NULL,
 CONSTRAINT [PK_PackageHousingContractRoom] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[PackageOperation]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[PackageOperation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageId] [int] NOT NULL,
	[PriceDetailId] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_PackageOperation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[PackagePhotos]    Script Date: 04/01/2024 2:18:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[PackagePhotos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageId] [int] NOT NULL,
	[PhotoUrl] [varchar](2500) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[PhotoId] [varchar](2500) NOT NULL,
 CONSTRAINT [PK_PackagePhotos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[PackageServiceProviderAdditionalService]    Script Date: 04/01/2024 2:18:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[PackageServiceProviderAdditionalService](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageId] [int] NOT NULL,
	[ServiceProviderAdditionalServiceId] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[PriceDetailId] [int] NOT NULL,
 CONSTRAINT [PK_PackageServiceProviderAdditionalService] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[PackageTransportationPath]    Script Date: 04/01/2024 2:18:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[PackageTransportationPath](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageId] [int] NOT NULL,
	[TransportationPathId] [uniqueidentifier] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[Capacity] [int] NULL,
	[TransportationSpecialContractId] [int] NULL,
	[DescriptionAr] [nvarchar](4000) NULL,
	[DescriptionEn] [varchar](4000) NULL,
	[PriceDetailId] [int] NOT NULL,
 CONSTRAINT [PK_PackageTransportationPath] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[PriceDetail]    Script Date: 04/01/2024 2:18:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[PriceDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BasePrice] [money] NOT NULL,
	[ProfitMargin] [money] NOT NULL,
	[ProfitPrice] [money] NOT NULL,
	[ProfitPriceVat] [money] NOT NULL,
	[BasicFee] [money] NOT NULL,
	[BasicFeeVat] [money] NOT NULL,
	[CollectionFee] [money] NOT NULL,
	[CollectionFeeVat] [money] NOT NULL,
	[Price] [money] NOT NULL,
	[Vat] [money] NOT NULL,
	[TotalPrice] [money] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_PriceDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[PricingStructure]    Script Date: 04/01/2024 2:18:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[PricingStructure](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MainClassification] [smallint] NOT NULL,
	[SubClassification] [smallint] NOT NULL,
	[PricingServiceOwner] [smallint] NOT NULL,
	[CampId] [uniqueidentifier] NULL,
	[IsRefundable] [bit] NOT NULL,
	[IsVatApplied] [bit] NOT NULL,
	[Price] [money] NOT NULL,
	[BasicFee] [money] NOT NULL,
	[BasicFeeVat] [money] NOT NULL,
	[CollectionFee] [money] NOT NULL,
	[CollectionFeeVat] [money] NOT NULL,
	[Vat] [money] NOT NULL,
	[TotalPrice] [money] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[BasePrice] [money] NOT NULL,
	[BaseVat] [money] NOT NULL,
 CONSTRAINT [PK_PricingStructure] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[ServiceProvider]    Script Date: 04/01/2024 2:18:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[ServiceProvider](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NULL,
	[NameEn] [varchar](500) NOT NULL,
	[NameAr] [nvarchar](500) NULL,
	[ImageUrl] [varchar](2048) NULL,
	[LinkUrl] [varchar](500) NULL,
	[Email] [varchar](100) NOT NULL,
	[MobileNumber] [varchar](20) NOT NULL,
	[PhoneNumber] [varchar](20) NULL,
	[AddressEn] [nvarchar](500) NULL,
	[LocationLongitude] [nvarchar](20) NULL,
	[LocationLatitude] [nvarchar](20) NULL,
	[IBAN] [varchar](36) NULL,
	[RepresentativeNameAr] [nvarchar](50) NULL,
	[RepresentativeNameEn] [nvarchar](50) NULL,
	[RepresentativePhoneNumber] [nvarchar](20) NULL,
	[RepresentativeEmail] [varchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[ServiceProviderQuota] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[AddressAr] [nvarchar](500) NULL,
	[DescriptionAr] [nvarchar](4000) NULL,
	[DescriptionEn] [nvarchar](4000) NULL,
	[BannerId] [nvarchar](50) NULL,
	[BannerUrl] [varchar](2048) NULL,
	[Facebook] [varchar](250) NULL,
	[Instagram] [varchar](250) NULL,
	[Twitter] [varchar](250) NULL,
	[Whatsapp] [varchar](250) NULL,
	[AllowPublish] [bit] NOT NULL,
	[AllowUnPublish] [bit] NOT NULL,
	[B2CQuota] [int] NOT NULL,
	[CourtesyQuota] [int] NOT NULL,
	[MinistryQuota] [int] NOT NULL,
 CONSTRAINT [PK_ServiceProvider] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[ServiceProviderAdditionalServices]    Script Date: 04/01/2024 2:18:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[ServiceProviderAdditionalServices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceProviderId] [int] NOT NULL,
	[AdditionalServiceId] [uniqueidentifier] NOT NULL,
	[Quantity] [int] NOT NULL,
	[QuantityUsed] [int] NOT NULL,
	[PhotoUrl] [nvarchar](max) NOT NULL,
	[DescriptionAr] [nvarchar](4000) NOT NULL,
	[DescriptionEn] [varchar](4000) NOT NULL,
	[Optional] [bit] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[Price] [money] NOT NULL,
	[PhotoId] [nvarchar](max) NOT NULL,
	[RowVersion] [timestamp] NULL,
 CONSTRAINT [PK_ServiceProviderAdditionalServices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Packages].[ServiceProviderGroundCenter]    Script Date: 04/01/2024 2:18:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[ServiceProviderGroundCenter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceProviderId] [int] NOT NULL,
	[CityId] [uniqueidentifier] NOT NULL,
	[NameAr] [nvarchar](250) NOT NULL,
	[NameEn] [varchar](250) NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[Code] [varchar](20) NULL,
 CONSTRAINT [PK_ServiceProviderGroundCenter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[ServiceProviderPackageCategory]    Script Date: 04/01/2024 2:18:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[ServiceProviderPackageCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceProviderId] [int] NOT NULL,
	[PackageCategoryId] [uniqueidentifier] NOT NULL,
	[QuotaType] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ServiceProviderPackageCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[ServiceProviderPhoto]    Script Date: 04/01/2024 2:18:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[ServiceProviderPhoto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceProviderId] [int] NOT NULL,
	[ImageUrl] [varchar](2048) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[ImageId] [varchar](50) NULL,
 CONSTRAINT [PK_ServiceProviderPhoto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[TransportationSpecialContract]    Script Date: 04/01/2024 2:18:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[TransportationSpecialContract](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ContractId] [bigint] NOT NULL,
	[ServiceProviderId] [int] NOT NULL,
	[TransportationProviderId] [uniqueidentifier] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_TransportationSpecialContract] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Packages].[TransportationSpecialContractRoute]    Script Date: 04/01/2024 2:18:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Packages].[TransportationSpecialContractRoute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NULL,
	[TotalPrice] [money] NOT NULL,
	[UpgradedPrice] [money] NOT NULL,
	[TransportationSpecialContractId] [int] NOT NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModified] [datetime2](7) NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[Capacity] [int] NOT NULL,
	[TransportationPathId] [uniqueidentifier] NOT NULL,
	[PriceWithoutVat] [money] NOT NULL,
 CONSTRAINT [PK_TransportationSpecialContractRoute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Admins].[Airline] ADD  DEFAULT ((0)) FOR [LookupType]
GO
ALTER TABLE [Admins].[Airport] ADD  DEFAULT ((0)) FOR [LookupType]
GO
ALTER TABLE [Admins].[Camp] ADD  DEFAULT ((0)) FOR [B2CQuota]
GO
ALTER TABLE [Admins].[Camp] ADD  DEFAULT (N'') FOR [DescriptionAR]
GO
ALTER TABLE [Admins].[Camp] ADD  DEFAULT (N'') FOR [DescriptionEN]
GO
ALTER TABLE [Admins].[Camp] ADD  DEFAULT ((0)) FOR [PiligrimsQuota]
GO
ALTER TABLE [Admins].[Camp] ADD  DEFAULT ((0)) FOR [CourtesyQuota]
GO
ALTER TABLE [Admins].[Camp] ADD  DEFAULT ((0)) FOR [MinistryQuota]
GO
ALTER TABLE [Admins].[CampPackageCategory] ADD  DEFAULT ((0)) FOR [PackageCategoryId]
GO
ALTER TABLE [Admins].[City] ADD  DEFAULT ((0)) FOR [LookupType]
GO
ALTER TABLE [Admins].[Continent] ADD  DEFAULT ((0)) FOR [ViewOrder]
GO
ALTER TABLE [Admins].[Country] ADD  CONSTRAINT [DF_Country_IsGcc]  DEFAULT ((0)) FOR [IsGcc]
GO
ALTER TABLE [Admins].[Country] ADD  DEFAULT (CONVERT([bit],(1))) FOR [IsCourtesyQuotaCheckEnabled]
GO
ALTER TABLE [Admins].[Country] ADD  DEFAULT (CONVERT([bit],(1))) FOR [IsMinistryQuotaCheckEnabled]
GO
ALTER TABLE [Admins].[Country] ADD  DEFAULT (CONVERT([bit],(1))) FOR [IsCountryQoutaCheckEnabled]
GO
ALTER TABLE [Admins].[Country] ADD  DEFAULT (CONVERT([bit],(1))) FOR [IsResidentsQoutaCheckEnabled]
GO
ALTER TABLE [Admins].[Country] ADD  DEFAULT ((0.0)) FOR [ResidentsQoutaRatio]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] ADD  DEFAULT ((0)) FOR [AvailableB2CGlobalQuota]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] ADD  DEFAULT ((0)) FOR [AvailableCourtesyGlobalQuota]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] ADD  DEFAULT ((0)) FOR [AvailableMinistryGlobalQuota]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsB2CQuotaEnabled]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCourtesyQuotaEnabled]
GO
ALTER TABLE [Admins].[GlobalQuotaSetting] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsMinistryQuotaEnabled]
GO
ALTER TABLE [Admins].[HousingProvider] ADD  DEFAULT ('') FOR [DescriptionEn]
GO
ALTER TABLE [Admins].[HousingProvider] ADD  DEFAULT ((0.0)) FOR [BookingClassification]
GO
ALTER TABLE [Admins].[HousingProvider] ADD  DEFAULT ((0.0)) FOR [BookingRate]
GO
ALTER TABLE [Admins].[HousingProvider] ADD  DEFAULT ((0.0)) FOR [TripAdvisorClassification]
GO
ALTER TABLE [Admins].[HousingProvider] ADD  DEFAULT ((0.0)) FOR [TripAdvisorRate]
GO
ALTER TABLE [Admins].[PackageCategory] ADD  DEFAULT ((0)) FOR [QuotaType]
GO
ALTER TABLE [Admins].[PackageCategory] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsMadinahRequired]
GO
ALTER TABLE [Admins].[PackageCategory] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsTourGuideRequired]
GO
ALTER TABLE [Admins].[PackageCategory] ADD  DEFAULT (CONVERT([smallint],(0))) FOR [PackageHousingType]
GO
ALTER TABLE [Admins].[PackageCategory] ADD  DEFAULT ((0)) FOR [RatingFrom]
GO
ALTER TABLE [Admins].[PackageCategory] ADD  DEFAULT ((0)) FOR [RatingTo]
GO
ALTER TABLE [Admins].[ServiceCenter] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsHelpAndSupportCenter]
GO
ALTER TABLE [Admins].[ServiceCenterAppointment] ADD  DEFAULT ('') FOR [Email]
GO
ALTER TABLE [Admins].[ServiceCenterAppointment] ADD  DEFAULT ('') FOR [MobileNumber]
GO
ALTER TABLE [Admins].[ServiceCenterAppointment] ADD  DEFAULT ('00:00:00') FOR [Time]
GO
ALTER TABLE [Admins].[TourGuideRegistration] ADD  DEFAULT ((0)) FOR [MinPilgrimsCount]
GO
ALTER TABLE [Admins].[TransportationPath] ADD  DEFAULT ((0.0)) FOR [PriceWithoutVat]
GO
ALTER TABLE [Admins].[TransportationPath] ADD  DEFAULT ((0.0)) FOR [TotalPrice]
GO
ALTER TABLE [Applicants].[Applicant] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsMain]
GO
ALTER TABLE [Applicants].[ApplicantDeleteReason] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ApplicationId]
GO
ALTER TABLE [Applicants].[ApplicantPreference] ADD  DEFAULT (CONVERT([bit],(0))) FOR [Asthma]
GO
ALTER TABLE [Packages].[FlightContract] ADD  DEFAULT ((0)) FOR [CapacityUsed]
GO
ALTER TABLE [Packages].[FlightRoute] ADD  DEFAULT (N'') FOR [ArrivalTerminal]
GO
ALTER TABLE [Packages].[FlightRoute] ADD  DEFAULT (N'') FOR [DepartureTerminal]
GO
ALTER TABLE [Packages].[FoodContract] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsActive]
GO
ALTER TABLE [Packages].[FoodContract] ADD  DEFAULT ((0.0)) FOR [PriceWithoutVAT]
GO
ALTER TABLE [Packages].[FoodContract] ADD  DEFAULT ((0)) FOR [MealType]
GO
ALTER TABLE [Packages].[FoodContractMenu] ADD  DEFAULT ((0)) FOR [FoodContractId]
GO
ALTER TABLE [Packages].[HousingContract] ADD  DEFAULT ('') FOR [HousePhoneNumber]
GO
ALTER TABLE [Packages].[HousingContract] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsActive]
GO
ALTER TABLE [Packages].[HousingContract] ADD  DEFAULT ((0.0)) FOR [PriceWithoutVat]
GO
ALTER TABLE [Packages].[HousingContract] ADD  DEFAULT ((0.0)) FOR [TotalPrice]
GO
ALTER TABLE [Packages].[HousingContractRoom] ADD  DEFAULT ((0)) FOR [HousingContractId]
GO
ALTER TABLE [Packages].[Package] ADD  DEFAULT ((0)) FOR [QuotaType]
GO
ALTER TABLE [Packages].[Package] ADD  DEFAULT ((0)) FOR [MakkahGroundCenterId]
GO
ALTER TABLE [Packages].[PackageFoodContract] ADD  DEFAULT ((0)) FOR [PriceDetailId]
GO
ALTER TABLE [Packages].[PackageHousingContractRoom] ADD  DEFAULT ((0)) FOR [PriceDetailId]
GO
ALTER TABLE [Packages].[PackagePhotos] ADD  DEFAULT ('') FOR [PhotoId]
GO
ALTER TABLE [Packages].[PackageServiceProviderAdditionalService] ADD  DEFAULT ((0)) FOR [PriceDetailId]
GO
ALTER TABLE [Packages].[PackageTransportationPath] ADD  DEFAULT ((0)) FOR [PriceDetailId]
GO
ALTER TABLE [Packages].[PricingStructure] ADD  DEFAULT ((0.0)) FOR [BasePrice]
GO
ALTER TABLE [Packages].[PricingStructure] ADD  DEFAULT ((0.0)) FOR [BaseVat]
GO
ALTER TABLE [Packages].[ServiceProvider] ADD  DEFAULT (CONVERT([bit],(0))) FOR [AllowPublish]
GO
ALTER TABLE [Packages].[ServiceProvider] ADD  DEFAULT (CONVERT([bit],(0))) FOR [AllowUnPublish]
GO
ALTER TABLE [Packages].[ServiceProvider] ADD  DEFAULT ((0)) FOR [B2CQuota]
GO
ALTER TABLE [Packages].[ServiceProvider] ADD  DEFAULT ((0)) FOR [CourtesyQuota]
GO
ALTER TABLE [Packages].[ServiceProvider] ADD  DEFAULT ((0)) FOR [MinistryQuota]
GO
ALTER TABLE [Packages].[ServiceProviderAdditionalServices] ADD  DEFAULT (N'') FOR [PhotoId]
GO
ALTER TABLE [Packages].[TransportationSpecialContract] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsActive]
GO
ALTER TABLE [Packages].[TransportationSpecialContractRoute] ADD  DEFAULT ((0)) FOR [TransportationSpecialContractId]
GO
ALTER TABLE [Packages].[TransportationSpecialContractRoute] ADD  DEFAULT ((0)) FOR [Capacity]
GO
ALTER TABLE [Packages].[TransportationSpecialContractRoute] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TransportationPathId]
GO
ALTER TABLE [Packages].[TransportationSpecialContractRoute] ADD  DEFAULT ((0.0)) FOR [PriceWithoutVat]
GO
ALTER TABLE [Admins].[AdditionalService]  WITH NOCHECK ADD  CONSTRAINT [FK_AdditionalService_AdditionalServiceType_AdditionalServiceTypeId] FOREIGN KEY([AdditionalServiceTypeId])
REFERENCES [Admins].[AdditionalServiceType] ([Id])
GO
ALTER TABLE [Admins].[AdditionalService] NOCHECK CONSTRAINT [FK_AdditionalService_AdditionalServiceType_AdditionalServiceTypeId]
GO
ALTER TABLE [Admins].[CampMedia]  WITH NOCHECK ADD  CONSTRAINT [FK_CampMedia_Camp_CampId] FOREIGN KEY([CampId])
REFERENCES [Admins].[Camp] ([Id])
GO
ALTER TABLE [Admins].[CampMedia] NOCHECK CONSTRAINT [FK_CampMedia_Camp_CampId]
GO
ALTER TABLE [Admins].[CampPackageCategory]  WITH NOCHECK ADD  CONSTRAINT [FK_CampPackageCategory_Camp_CampId] FOREIGN KEY([CampId])
REFERENCES [Admins].[Camp] ([Id])
GO
ALTER TABLE [Admins].[CampPackageCategory] NOCHECK CONSTRAINT [FK_CampPackageCategory_Camp_CampId]
GO
ALTER TABLE [Admins].[CampTransportation]  WITH NOCHECK ADD  CONSTRAINT [FK_CampTransportation_Camp_CampId] FOREIGN KEY([CampId])
REFERENCES [Admins].[Camp] ([Id])
GO
ALTER TABLE [Admins].[CampTransportation] NOCHECK CONSTRAINT [FK_CampTransportation_Camp_CampId]
GO
ALTER TABLE [Admins].[CampTransportation]  WITH NOCHECK ADD  CONSTRAINT [FK_CampTransportation_SystemLanguage_SystemLanguageId] FOREIGN KEY([SystemLanguageId])
REFERENCES [Admins].[SystemLanguage] ([Id])
GO
ALTER TABLE [Admins].[CampTransportation] NOCHECK CONSTRAINT [FK_CampTransportation_SystemLanguage_SystemLanguageId]
GO
ALTER TABLE [Admins].[City]  WITH NOCHECK ADD  CONSTRAINT [FK_City_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [Admins].[Country] ([Id])
GO
ALTER TABLE [Admins].[City] NOCHECK CONSTRAINT [FK_City_Country_CountryId]
GO
ALTER TABLE [Admins].[Country]  WITH NOCHECK ADD  CONSTRAINT [FK_Country_Continent_ContinentId] FOREIGN KEY([ContinentId])
REFERENCES [Admins].[Continent] ([Id])
GO
ALTER TABLE [Admins].[Country] NOCHECK CONSTRAINT [FK_Country_Continent_ContinentId]
GO
ALTER TABLE [Admins].[CountryAllowedAge]  WITH NOCHECK ADD  CONSTRAINT [FK_CountryAllowedAge_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [Admins].[Country] ([Id])
GO
ALTER TABLE [Admins].[CountryAllowedAge] NOCHECK CONSTRAINT [FK_CountryAllowedAge_Country_CountryId]
GO
ALTER TABLE [Admins].[CountryGroup]  WITH NOCHECK ADD  CONSTRAINT [FK_CountryGroup_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [Admins].[Country] ([Id])
GO
ALTER TABLE [Admins].[CountryGroup] NOCHECK CONSTRAINT [FK_CountryGroup_Country_CountryId]
GO
ALTER TABLE [Admins].[CountryNote]  WITH NOCHECK ADD  CONSTRAINT [FK_CountryNote_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [Admins].[Country] ([Id])
GO
ALTER TABLE [Admins].[CountryNote] NOCHECK CONSTRAINT [FK_CountryNote_Country_CountryId]
GO
ALTER TABLE [Admins].[EmbassyQuota]  WITH NOCHECK ADD  CONSTRAINT [FK_EmbassyQuota_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [Admins].[Country] ([Id])
GO
ALTER TABLE [Admins].[EmbassyQuota] NOCHECK CONSTRAINT [FK_EmbassyQuota_Country_CountryId]
GO
ALTER TABLE [Admins].[EmbassyQuota]  WITH NOCHECK ADD  CONSTRAINT [FK_EmbassyQuota_Embassy_EmbassyId] FOREIGN KEY([EmbassyId])
REFERENCES [Admins].[Embassy] ([Id])
GO
ALTER TABLE [Admins].[EmbassyQuota] NOCHECK CONSTRAINT [FK_EmbassyQuota_Embassy_EmbassyId]
GO
ALTER TABLE [Admins].[HousingProvider]  WITH NOCHECK ADD  CONSTRAINT [FK_HousingProvider_City_CityId] FOREIGN KEY([CityId])
REFERENCES [Admins].[City] ([Id])
GO
ALTER TABLE [Admins].[HousingProvider] NOCHECK CONSTRAINT [FK_HousingProvider_City_CityId]
GO
ALTER TABLE [Admins].[HousingProvider]  WITH NOCHECK ADD  CONSTRAINT [FK_HousingProvider_HousingZone_HousingZoneId] FOREIGN KEY([HousingZoneId])
REFERENCES [Admins].[HousingZone] ([Id])
GO
ALTER TABLE [Admins].[HousingProvider] NOCHECK CONSTRAINT [FK_HousingProvider_HousingZone_HousingZoneId]
GO
ALTER TABLE [Admins].[HousingProviderPhoto]  WITH NOCHECK ADD  CONSTRAINT [FK_HousingProviderPhoto_HousingProvider_HousingProviderId] FOREIGN KEY([HousingProviderId])
REFERENCES [Admins].[HousingProvider] ([Id])
GO
ALTER TABLE [Admins].[HousingProviderPhoto] NOCHECK CONSTRAINT [FK_HousingProviderPhoto_HousingProvider_HousingProviderId]
GO
ALTER TABLE [Admins].[HousingProviderRepresentativeContact]  WITH NOCHECK ADD  CONSTRAINT [FK_HousingProviderRepresentativeContact_HousingProvider_HousingProviderId] FOREIGN KEY([HousingProviderId])
REFERENCES [Admins].[HousingProvider] ([Id])
GO
ALTER TABLE [Admins].[HousingProviderRepresentativeContact] NOCHECK CONSTRAINT [FK_HousingProviderRepresentativeContact_HousingProvider_HousingProviderId]
GO
ALTER TABLE [Admins].[HousingProviderService]  WITH NOCHECK ADD  CONSTRAINT [FK_HousingProviderService_HousingProvider_HousingProviderId] FOREIGN KEY([HousingProviderId])
REFERENCES [Admins].[HousingProvider] ([Id])
GO
ALTER TABLE [Admins].[HousingProviderService] NOCHECK CONSTRAINT [FK_HousingProviderService_HousingProvider_HousingProviderId]
GO
ALTER TABLE [Admins].[LookupLocalization]  WITH NOCHECK ADD  CONSTRAINT [FK_LookupLocalization_SystemLanguage_SystemLanguageId] FOREIGN KEY([SystemLanguageId])
REFERENCES [Admins].[SystemLanguage] ([Id])
GO
ALTER TABLE [Admins].[LookupLocalization] NOCHECK CONSTRAINT [FK_LookupLocalization_SystemLanguage_SystemLanguageId]
GO
ALTER TABLE [Admins].[PackageCategory]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageCategory_HousingZone_HousingZoneId] FOREIGN KEY([HousingZoneId])
REFERENCES [Admins].[HousingZone] ([Id])
GO
ALTER TABLE [Admins].[PackageCategory] NOCHECK CONSTRAINT [FK_PackageCategory_HousingZone_HousingZoneId]
GO
ALTER TABLE [Admins].[ReservationPeriodException]  WITH NOCHECK ADD  CONSTRAINT [FK_ReservationPeriodException_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [Admins].[Country] ([Id])
GO
ALTER TABLE [Admins].[ReservationPeriodException] NOCHECK CONSTRAINT [FK_ReservationPeriodException_Country_CountryId]
GO
ALTER TABLE [Admins].[ReservationPeriodException]  WITH NOCHECK ADD  CONSTRAINT [FK_ReservationPeriodException_ReservationPeriod_ReservationPeriodId] FOREIGN KEY([ReservationPeriodId])
REFERENCES [Admins].[ReservationPeriod] ([Id])
GO
ALTER TABLE [Admins].[ReservationPeriodException] NOCHECK CONSTRAINT [FK_ReservationPeriodException_ReservationPeriod_ReservationPeriodId]
GO
ALTER TABLE [Admins].[ServiceCenter]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceCenter_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [Admins].[Country] ([Id])
GO
ALTER TABLE [Admins].[ServiceCenter] NOCHECK CONSTRAINT [FK_ServiceCenter_Country_CountryId]
GO
ALTER TABLE [Admins].[ServiceCenterAppointment]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceCenterAppointment_ServiceCenter_ServiceCenterId] FOREIGN KEY([ServiceCenterId])
REFERENCES [Admins].[ServiceCenter] ([Id])
GO
ALTER TABLE [Admins].[ServiceCenterAppointment] NOCHECK CONSTRAINT [FK_ServiceCenterAppointment_ServiceCenter_ServiceCenterId]
GO
ALTER TABLE [Admins].[ServiceCenterWorkHours]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceCenterWorkHours_ServiceCenter_ServiceCenterId] FOREIGN KEY([ServiceCenterId])
REFERENCES [Admins].[ServiceCenter] ([Id])
GO
ALTER TABLE [Admins].[ServiceCenterWorkHours] NOCHECK CONSTRAINT [FK_ServiceCenterWorkHours_ServiceCenter_ServiceCenterId]
GO
ALTER TABLE [Admins].[TourGuideRegistrationPeriodException]  WITH NOCHECK ADD  CONSTRAINT [FK_TourGuideRegistrationPeriodException_TourGuideRegistration_TourGuideRegistrationId] FOREIGN KEY([TourGuideRegistrationId])
REFERENCES [Admins].[TourGuideRegistration] ([Id])
GO
ALTER TABLE [Admins].[TourGuideRegistrationPeriodException] NOCHECK CONSTRAINT [FK_TourGuideRegistrationPeriodException_TourGuideRegistration_TourGuideRegistrationId]
GO
ALTER TABLE [Admins].[TourGuideRegistrationPilgrimException]  WITH NOCHECK ADD  CONSTRAINT [FK_TourGuideRegistrationPilgrimException_TourGuideRegistration_TourGuideRegistrationId] FOREIGN KEY([TourGuideRegistrationId])
REFERENCES [Admins].[TourGuideRegistration] ([Id])
GO
ALTER TABLE [Admins].[TourGuideRegistrationPilgrimException] NOCHECK CONSTRAINT [FK_TourGuideRegistrationPilgrimException_TourGuideRegistration_TourGuideRegistrationId]
GO
ALTER TABLE [Applicants].[Applicant]  WITH NOCHECK ADD  CONSTRAINT [FK_Applicant_Application_ApplicationId] FOREIGN KEY([ApplicationId])
REFERENCES [Applicants].[Application] ([Id])
GO
ALTER TABLE [Applicants].[Applicant] NOCHECK CONSTRAINT [FK_Applicant_Application_ApplicationId]
GO
ALTER TABLE [Applicants].[ApplicantAllergy]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantAllergy_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantAllergy] NOCHECK CONSTRAINT [FK_ApplicantAllergy_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantArrivalDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantArrivalDetail_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantArrivalDetail] NOCHECK CONSTRAINT [FK_ApplicantArrivalDetail_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantBankDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantBankDetail_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantBankDetail] NOCHECK CONSTRAINT [FK_ApplicantBankDetail_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantContactDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantContactDetail_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantContactDetail] NOCHECK CONSTRAINT [FK_ApplicantContactDetail_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantDocument]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantDocument_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantDocument] NOCHECK CONSTRAINT [FK_ApplicantDocument_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantHistory_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantHistory] NOCHECK CONSTRAINT [FK_ApplicantHistory_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantOccupationDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantOccupationDetail_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantOccupationDetail] NOCHECK CONSTRAINT [FK_ApplicantOccupationDetail_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantOtherNationality]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantOtherNationality_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantOtherNationality] NOCHECK CONSTRAINT [FK_ApplicantOtherNationality_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantPreference]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantPreference_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantPreference] NOCHECK CONSTRAINT [FK_ApplicantPreference_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantRejectionReason]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantRejectionReason_ApplicantHistory_ApplicantHistoryId] FOREIGN KEY([ApplicantHistoryId])
REFERENCES [Applicants].[ApplicantHistory] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantRejectionReason] NOCHECK CONSTRAINT [FK_ApplicantRejectionReason_ApplicantHistory_ApplicantHistoryId]
GO
ALTER TABLE [Applicants].[ApplicantRelativeResident]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantRelativeResident_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantRelativeResident] NOCHECK CONSTRAINT [FK_ApplicantRelativeResident_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantTravelHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantTravelHistory_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantTravelHistory] NOCHECK CONSTRAINT [FK_ApplicantTravelHistory_Applicant_ApplicantId]
GO
ALTER TABLE [Applicants].[ApplicantVisaAnswer]  WITH NOCHECK ADD  CONSTRAINT [FK_ApplicantVisaAnswer_Applicant_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [Applicants].[Applicant] ([Id])
GO
ALTER TABLE [Applicants].[ApplicantVisaAnswer] NOCHECK CONSTRAINT [FK_ApplicantVisaAnswer_Applicant_ApplicantId]
GO
ALTER TABLE [MoneyFunds].[BankDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_BankDetail_Wallet_WalletId] FOREIGN KEY([WalletId])
REFERENCES [MoneyFunds].[Wallet] ([Id])
GO
ALTER TABLE [MoneyFunds].[BankDetail] NOCHECK CONSTRAINT [FK_BankDetail_Wallet_WalletId]
GO
ALTER TABLE [MoneyFunds].[BillingAddress]  WITH NOCHECK ADD  CONSTRAINT [FK_BillingAddress_Wallet_WalletId] FOREIGN KEY([WalletId])
REFERENCES [MoneyFunds].[Wallet] ([Id])
GO
ALTER TABLE [MoneyFunds].[BillingAddress] NOCHECK CONSTRAINT [FK_BillingAddress_Wallet_WalletId]
GO
ALTER TABLE [MoneyFunds].[WalletDiscount]  WITH NOCHECK ADD  CONSTRAINT [FK_WalletDiscount_Wallet_WalletId] FOREIGN KEY([WalletId])
REFERENCES [MoneyFunds].[Wallet] ([Id])
GO
ALTER TABLE [MoneyFunds].[WalletDiscount] NOCHECK CONSTRAINT [FK_WalletDiscount_Wallet_WalletId]
GO
ALTER TABLE [MoneyFunds].[WalletRefundTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_WalletRefundTransaction_WalletTransaction_WalletTransactionId] FOREIGN KEY([WalletTransactionId])
REFERENCES [MoneyFunds].[WalletTransaction] ([Id])
GO
ALTER TABLE [MoneyFunds].[WalletRefundTransaction] NOCHECK CONSTRAINT [FK_WalletRefundTransaction_WalletTransaction_WalletTransactionId]
GO
ALTER TABLE [MoneyFunds].[WalletTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_WalletTransaction_Wallet_WalletId] FOREIGN KEY([WalletId])
REFERENCES [MoneyFunds].[Wallet] ([Id])
GO
ALTER TABLE [MoneyFunds].[WalletTransaction] NOCHECK CONSTRAINT [FK_WalletTransaction_Wallet_WalletId]
GO
ALTER TABLE [MoneyFunds].[WalletTransactionDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_WalletTransactionDetail_Wallet_WalletId] FOREIGN KEY([WalletId])
REFERENCES [MoneyFunds].[Wallet] ([Id])
GO
ALTER TABLE [MoneyFunds].[WalletTransactionDetail] NOCHECK CONSTRAINT [FK_WalletTransactionDetail_Wallet_WalletId]
GO
ALTER TABLE [MoneyFunds].[WalletTransactionDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_WalletTransactionDetail_WalletTransaction_WalletTransactionId] FOREIGN KEY([WalletTransactionId])
REFERENCES [MoneyFunds].[WalletTransaction] ([Id])
GO
ALTER TABLE [MoneyFunds].[WalletTransactionDetail] NOCHECK CONSTRAINT [FK_WalletTransactionDetail_WalletTransaction_WalletTransactionId]
GO
ALTER TABLE [Notifications].[RequestAction]  WITH NOCHECK ADD  CONSTRAINT [FK_RequestAction_Notification_NotificationId] FOREIGN KEY([NotificationId])
REFERENCES [Notifications].[Notification] ([Id])
GO
ALTER TABLE [Notifications].[RequestAction] NOCHECK CONSTRAINT [FK_RequestAction_Notification_NotificationId]
GO
ALTER TABLE [Packages].[FlightContract]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightContract_FlightTrip_ArrivalTripId] FOREIGN KEY([ArrivalTripId])
REFERENCES [Packages].[FlightTrip] ([Id])
GO
ALTER TABLE [Packages].[FlightContract] NOCHECK CONSTRAINT [FK_FlightContract_FlightTrip_ArrivalTripId]
GO
ALTER TABLE [Packages].[FlightContract]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightContract_FlightTrip_ReturnTripId] FOREIGN KEY([ReturnTripId])
REFERENCES [Packages].[FlightTrip] ([Id])
GO
ALTER TABLE [Packages].[FlightContract] NOCHECK CONSTRAINT [FK_FlightContract_FlightTrip_ReturnTripId]
GO
ALTER TABLE [Packages].[FlightContract]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightContract_PriceDetail_PriceDetailId] FOREIGN KEY([PriceDetailId])
REFERENCES [Packages].[PriceDetail] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Packages].[FlightContract] NOCHECK CONSTRAINT [FK_FlightContract_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[FlightContract]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightContract_ServiceProvider_ServiceProviderId] FOREIGN KEY([ServiceProviderId])
REFERENCES [Packages].[ServiceProvider] ([Id])
GO
ALTER TABLE [Packages].[FlightContract] NOCHECK CONSTRAINT [FK_FlightContract_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[FlightContractCountry]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightContractCountry_FlightContract_FlightContractId] FOREIGN KEY([FlightContractId])
REFERENCES [Packages].[FlightContract] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Packages].[FlightContractCountry] NOCHECK CONSTRAINT [FK_FlightContractCountry_FlightContract_FlightContractId]
GO
ALTER TABLE [Packages].[FlightRoute]  WITH NOCHECK ADD  CONSTRAINT [FK_FlightRoute_FlightTrip_FlightTripId] FOREIGN KEY([FlightTripId])
REFERENCES [Packages].[FlightTrip] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Packages].[FlightRoute] NOCHECK CONSTRAINT [FK_FlightRoute_FlightTrip_FlightTripId]
GO
ALTER TABLE [Packages].[FoodContract]  WITH NOCHECK ADD  CONSTRAINT [FK_FoodContract_ServiceProvider_ServiceProviderId] FOREIGN KEY([ServiceProviderId])
REFERENCES [Packages].[ServiceProvider] ([Id])
GO
ALTER TABLE [Packages].[FoodContract] NOCHECK CONSTRAINT [FK_FoodContract_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[FoodContractMenu]  WITH NOCHECK ADD  CONSTRAINT [FK_FoodContractMenu_FoodContract_FoodContractId] FOREIGN KEY([FoodContractId])
REFERENCES [Packages].[FoodContract] ([Id])
GO
ALTER TABLE [Packages].[FoodContractMenu] NOCHECK CONSTRAINT [FK_FoodContractMenu_FoodContract_FoodContractId]
GO
ALTER TABLE [Packages].[HousingContract]  WITH NOCHECK ADD  CONSTRAINT [FK_HousingContract_ServiceProvider_ServiceProviderId] FOREIGN KEY([ServiceProviderId])
REFERENCES [Packages].[ServiceProvider] ([Id])
GO
ALTER TABLE [Packages].[HousingContract] NOCHECK CONSTRAINT [FK_HousingContract_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[HousingContractMeal]  WITH NOCHECK ADD  CONSTRAINT [FK_HousingContractMeal_HousingContract_HousingContractId] FOREIGN KEY([HousingContractId])
REFERENCES [Packages].[HousingContract] ([Id])
GO
ALTER TABLE [Packages].[HousingContractMeal] NOCHECK CONSTRAINT [FK_HousingContractMeal_HousingContract_HousingContractId]
GO
ALTER TABLE [Packages].[HousingContractRoom]  WITH NOCHECK ADD  CONSTRAINT [FK_HousingContractRoom_HousingContract_HousingContractId] FOREIGN KEY([HousingContractId])
REFERENCES [Packages].[HousingContract] ([Id])
GO
ALTER TABLE [Packages].[HousingContractRoom] NOCHECK CONSTRAINT [FK_HousingContractRoom_HousingContract_HousingContractId]
GO
ALTER TABLE [Packages].[Package]  WITH NOCHECK ADD  CONSTRAINT [FK_Package_ServiceProvider_ServiceProviderId] FOREIGN KEY([ServiceProviderId])
REFERENCES [Packages].[ServiceProvider] ([Id])
GO
ALTER TABLE [Packages].[Package] NOCHECK CONSTRAINT [FK_Package_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[Package]  WITH NOCHECK ADD  CONSTRAINT [FK_Package_ServiceProviderGroundCenter_MadinahGroundCenterId] FOREIGN KEY([MadinahGroundCenterId])
REFERENCES [Packages].[ServiceProviderGroundCenter] ([Id])
GO
ALTER TABLE [Packages].[Package] NOCHECK CONSTRAINT [FK_Package_ServiceProviderGroundCenter_MadinahGroundCenterId]
GO
ALTER TABLE [Packages].[Package]  WITH NOCHECK ADD  CONSTRAINT [FK_Package_ServiceProviderGroundCenter_MakkahGroundCenterId] FOREIGN KEY([MakkahGroundCenterId])
REFERENCES [Packages].[ServiceProviderGroundCenter] ([Id])
GO
ALTER TABLE [Packages].[Package] NOCHECK CONSTRAINT [FK_Package_ServiceProviderGroundCenter_MakkahGroundCenterId]
GO
ALTER TABLE [Packages].[PackageFlightContract]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageFlightContract_FlightContract_FlightContractId] FOREIGN KEY([FlightContractId])
REFERENCES [Packages].[FlightContract] ([Id])
GO
ALTER TABLE [Packages].[PackageFlightContract] NOCHECK CONSTRAINT [FK_PackageFlightContract_FlightContract_FlightContractId]
GO
ALTER TABLE [Packages].[PackageFlightContract]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageFlightContract_Package_PackageId] FOREIGN KEY([PackageId])
REFERENCES [Packages].[Package] ([Id])
GO
ALTER TABLE [Packages].[PackageFlightContract] NOCHECK CONSTRAINT [FK_PackageFlightContract_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageFoodContract]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageFoodContract_FoodContract_FoodContractId] FOREIGN KEY([FoodContractId])
REFERENCES [Packages].[FoodContract] ([Id])
GO
ALTER TABLE [Packages].[PackageFoodContract] NOCHECK CONSTRAINT [FK_PackageFoodContract_FoodContract_FoodContractId]
GO
ALTER TABLE [Packages].[PackageFoodContract]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageFoodContract_Package_PackageId] FOREIGN KEY([PackageId])
REFERENCES [Packages].[Package] ([Id])
GO
ALTER TABLE [Packages].[PackageFoodContract] NOCHECK CONSTRAINT [FK_PackageFoodContract_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageFoodContract]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageFoodContract_PriceDetail_PriceDetailId] FOREIGN KEY([PriceDetailId])
REFERENCES [Packages].[PriceDetail] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Packages].[PackageFoodContract] NOCHECK CONSTRAINT [FK_PackageFoodContract_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[PackageHousingContract]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageHousingContract_HousingContract_HousingContractId] FOREIGN KEY([HousingContractId])
REFERENCES [Packages].[HousingContract] ([Id])
GO
ALTER TABLE [Packages].[PackageHousingContract] NOCHECK CONSTRAINT [FK_PackageHousingContract_HousingContract_HousingContractId]
GO
ALTER TABLE [Packages].[PackageHousingContract]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageHousingContract_Package_PackageId] FOREIGN KEY([PackageId])
REFERENCES [Packages].[Package] ([Id])
GO
ALTER TABLE [Packages].[PackageHousingContract] NOCHECK CONSTRAINT [FK_PackageHousingContract_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageHousingContractRoom]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageHousingContractRoom_PackageHousingContract_PackageHousingContractId] FOREIGN KEY([PackageHousingContractId])
REFERENCES [Packages].[PackageHousingContract] ([Id])
GO
ALTER TABLE [Packages].[PackageHousingContractRoom] NOCHECK CONSTRAINT [FK_PackageHousingContractRoom_PackageHousingContract_PackageHousingContractId]
GO
ALTER TABLE [Packages].[PackageHousingContractRoom]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageHousingContractRoom_PriceDetail_PriceDetailId] FOREIGN KEY([PriceDetailId])
REFERENCES [Packages].[PriceDetail] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Packages].[PackageHousingContractRoom] NOCHECK CONSTRAINT [FK_PackageHousingContractRoom_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[PackageOperation]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageOperation_Package_PackageId] FOREIGN KEY([PackageId])
REFERENCES [Packages].[Package] ([Id])
GO
ALTER TABLE [Packages].[PackageOperation] NOCHECK CONSTRAINT [FK_PackageOperation_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageOperation]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageOperation_PriceDetail_PriceDetailId] FOREIGN KEY([PriceDetailId])
REFERENCES [Packages].[PriceDetail] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Packages].[PackageOperation] NOCHECK CONSTRAINT [FK_PackageOperation_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[PackagePhotos]  WITH NOCHECK ADD  CONSTRAINT [FK_PackagePhotos_Package_PackageId] FOREIGN KEY([PackageId])
REFERENCES [Packages].[Package] ([Id])
GO
ALTER TABLE [Packages].[PackagePhotos] NOCHECK CONSTRAINT [FK_PackagePhotos_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageServiceProviderAdditionalService]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageServiceProviderAdditionalService_Package_PackageId] FOREIGN KEY([PackageId])
REFERENCES [Packages].[Package] ([Id])
GO
ALTER TABLE [Packages].[PackageServiceProviderAdditionalService] NOCHECK CONSTRAINT [FK_PackageServiceProviderAdditionalService_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageServiceProviderAdditionalService]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageServiceProviderAdditionalService_PriceDetail_PriceDetailId] FOREIGN KEY([PriceDetailId])
REFERENCES [Packages].[PriceDetail] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Packages].[PackageServiceProviderAdditionalService] NOCHECK CONSTRAINT [FK_PackageServiceProviderAdditionalService_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[PackageServiceProviderAdditionalService]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageServiceProviderAdditionalService_ServiceProviderAdditionalServices_ServiceProviderAdditionalServiceId] FOREIGN KEY([ServiceProviderAdditionalServiceId])
REFERENCES [Packages].[ServiceProviderAdditionalServices] ([Id])
GO
ALTER TABLE [Packages].[PackageServiceProviderAdditionalService] NOCHECK CONSTRAINT [FK_PackageServiceProviderAdditionalService_ServiceProviderAdditionalServices_ServiceProviderAdditionalServiceId]
GO
ALTER TABLE [Packages].[PackageTransportationPath]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageTransportationPath_Package_PackageId] FOREIGN KEY([PackageId])
REFERENCES [Packages].[Package] ([Id])
GO
ALTER TABLE [Packages].[PackageTransportationPath] NOCHECK CONSTRAINT [FK_PackageTransportationPath_Package_PackageId]
GO
ALTER TABLE [Packages].[PackageTransportationPath]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageTransportationPath_PriceDetail_PriceDetailId] FOREIGN KEY([PriceDetailId])
REFERENCES [Packages].[PriceDetail] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Packages].[PackageTransportationPath] NOCHECK CONSTRAINT [FK_PackageTransportationPath_PriceDetail_PriceDetailId]
GO
ALTER TABLE [Packages].[PackageTransportationPath]  WITH NOCHECK ADD  CONSTRAINT [FK_PackageTransportationPath_TransportationSpecialContract_TransportationSpecialContractId] FOREIGN KEY([TransportationSpecialContractId])
REFERENCES [Packages].[TransportationSpecialContract] ([Id])
GO
ALTER TABLE [Packages].[PackageTransportationPath] NOCHECK CONSTRAINT [FK_PackageTransportationPath_TransportationSpecialContract_TransportationSpecialContractId]
GO
ALTER TABLE [Packages].[ServiceProviderAdditionalServices]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceProviderAdditionalServices_ServiceProvider_ServiceProviderId] FOREIGN KEY([ServiceProviderId])
REFERENCES [Packages].[ServiceProvider] ([Id])
GO
ALTER TABLE [Packages].[ServiceProviderAdditionalServices] NOCHECK CONSTRAINT [FK_ServiceProviderAdditionalServices_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[ServiceProviderGroundCenter]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceProviderGroundCenter_ServiceProvider_ServiceProviderId] FOREIGN KEY([ServiceProviderId])
REFERENCES [Packages].[ServiceProvider] ([Id])
GO
ALTER TABLE [Packages].[ServiceProviderGroundCenter] NOCHECK CONSTRAINT [FK_ServiceProviderGroundCenter_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[ServiceProviderPackageCategory]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceProviderPackageCategory_ServiceProvider_ServiceProviderId] FOREIGN KEY([ServiceProviderId])
REFERENCES [Packages].[ServiceProvider] ([Id])
GO
ALTER TABLE [Packages].[ServiceProviderPackageCategory] NOCHECK CONSTRAINT [FK_ServiceProviderPackageCategory_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[ServiceProviderPhoto]  WITH NOCHECK ADD  CONSTRAINT [FK_ServiceProviderPhoto_ServiceProvider_ServiceProviderId] FOREIGN KEY([ServiceProviderId])
REFERENCES [Packages].[ServiceProvider] ([Id])
GO
ALTER TABLE [Packages].[ServiceProviderPhoto] NOCHECK CONSTRAINT [FK_ServiceProviderPhoto_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[TransportationSpecialContract]  WITH NOCHECK ADD  CONSTRAINT [FK_TransportationSpecialContract_ServiceProvider_ServiceProviderId] FOREIGN KEY([ServiceProviderId])
REFERENCES [Packages].[ServiceProvider] ([Id])
GO
ALTER TABLE [Packages].[TransportationSpecialContract] NOCHECK CONSTRAINT [FK_TransportationSpecialContract_ServiceProvider_ServiceProviderId]
GO
ALTER TABLE [Packages].[TransportationSpecialContractRoute]  WITH NOCHECK ADD  CONSTRAINT [FK_TransportationSpecialContractRoute_TransportationSpecialContract_TransportationSpecialContractId] FOREIGN KEY([TransportationSpecialContractId])
REFERENCES [Packages].[TransportationSpecialContract] ([Id])
GO
ALTER TABLE [Packages].[TransportationSpecialContractRoute] NOCHECK CONSTRAINT [FK_TransportationSpecialContractRoute_TransportationSpecialContract_TransportationSpecialContractId]
GO
EXEC sp_MSForEachTable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"
GO