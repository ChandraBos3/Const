 use EIP
 go
 ---SQLSCM.#SCM_SP_PO_ConstZon_Details '27-aug-2018', '30-aug-2018', 1, 523

--alter PROCEDURE SQLSCM.#SCM_SP_PO_ConstZon_Details 
create PROCEDURE SQLSCM.#SCM_SP_PO_ConstZon_Details

(
			@dtFromDate   DATE,
			@dtToDate   DATE, 
			@intCompanyCode INT,
			@intUID INT,
			@ChrConstZonApplicable CHAR(1) = 'A',
			@intReturnMessage		INT = NULL OUTPUT,            
			@strReturnParameters	VARCHAR(500) = NULL OUTPUT,
			@intLoginAuditNumber	INT = 0
)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	--EXEC SQLACS.ACS_SP_User_Session_Validate @intUserID = @intUID, @intProcedureID = @@PROCID,
	--@intReturnMessage = @intReturnMessage OUTPUT, @intLoginAuditNumber = @intLoginAuditNumber  

	--IF @intReturnMessage != 90043 
	BEGIN
		SET @intReturnMessage = NULL

				DECLARE  @xml_iSTDet int  
				DECLARE @XML_Material_List TABLE  
				(  
				PO_Number VARCHAR(30) ,  
				Material_Code VARCHAR(50)  
				)  			
		
				--Create Table #Temp_Last_PO_Rate  (MaterialCode  varchar(15), Temp_Job_Location INT, LastPORate_Company money, Temp_Currency_Code INT)                             
				Create Table #Temp_PO_Company_Rate (Temp_Material_Code varchar(15), Temp_Job_Location INT,Temp_Currency_Code INT , LastPORate_Company money,)
				

CREATE TABLE #Temp_SCM_PO_Details
(
                        Temp_PO_Number VARCHAR(30),
                        Temp_PO_Amendment_No Int,
                        Temp_PO_Date     DATE,
                        Temp_Job_Code    VarChar(15),
                        Temp_Vendor_Code    VarChar(15),
                        Temp_Currency_Code   Int,
                        Temp_Location_Code Int,
                        Temp_Material_Code VARCHAR(30),
						Temp_Material_Group VARCHAR (30),
						Temp_Material_Group_Desc VARCHAR (300),
                        Temp_ConstZon_Applicable Char(1),
                        Temp_RC_Applicable Char(1),
                        Temp_Counter_Offer_Basic_Rate Money,
                        Temp_PO_Basic_Rate          Money,
						Temp_PO_Net_Rate          Money,
						Temp_PO_Qty Money,
						Temp_PO_Value Money,
                        Temp_National_Low_Rate Money,
						Temp_ConstZon_Lower_bound_Rate Money,
						Temp_ConstZon_Upper_bound_Rate Money,
						Temp_Constzon_skip_approval_required char(10),
						Temp_Last_PO_Rate_For_Location Money,
						Temp_Last_PO_Rate_From_Other_Location Money,
						Temp_UOM INT,
						Temp_Created_By INT,
						Temp_Location_Code_PO INT,
						Temp_Location_Desc VARCHAR(1000),
						Temp_Reason_for_Higher_Price VARCHAR(2000),
						Temp_Last_PO_Rate_From_Other_Location_Code_PO INT,
						Temp_materialcategorycode VARCHAR(500),
						Temp_materialcategory VARCHAR(500),
						Temp_EPM_Tag VARCHAR (15),
						Temp_PO_POA VARCHAR (15)
						
)

----------------Fresh PO

INSERT INTO #Temp_SCM_PO_Details
                        (Temp_PO_Number, Temp_PO_Amendment_No, Temp_PO_Date, Temp_Job_Code, Temp_Vendor_Code, 
                        Temp_Currency_Code, Temp_Material_Code, Temp_Material_Group, Temp_Material_Group_Desc,Temp_PO_Basic_Rate,Temp_PO_Net_Rate ,Temp_PO_Qty, Temp_PO_Value,
                        Temp_Counter_Offer_Basic_Rate, Temp_ConstZon_Applicable, Temp_RC_Applicable,Temp_Constzon_skip_approval_required,  Temp_National_Low_Rate,Temp_UOM,
						Temp_Created_By, Temp_Reason_for_Higher_Price,Temp_PO_POA )
	SELECT DISTINCT  HPO_PO_Number, HPO_Last_Amendment_Number,
										HPO_PO_Date, HPO_Job_Code, HPO_BA_Code, HPO_Currency_Code, DPO_Material_Code,MMAT_MG_CODE,MMGRP_Description, DPO_Basic_Rate,DPO_Net_Rate,DPO_Qty,DPO_Value,
										DCOFF_Basic_Rate, CASE WHEN DPOCD_Rate_Applicable IN ('Y','R') THEN 'Y' ELSE 'N' END, 
										CASE WHEN DPOCD_Rate_Applicable IN ('R') THEN 'Y' ELSE 'N' END,DPOCD_WF_SKIP_APPROVAL_REQUIRED,
										DPOCD_National_Low_Rate, MMAT_UOM_Code, HPO_Inserted_By, DPOCD_Remarks, SUBSTRING(hpo_po_number,6,2)
	FROM SQLSCM.SCM_H_Purchase_Orders, SQLSCM.SCM_D_Purchase_Orders, SQLMAS.GEN_M_Materials, 
					SQLSCM.SCM_D_Counter_Offer, SQLSCM.SCM_D_PO_ConstZon_Details,eip.sqlmas.GEN_M_Material_Groups
	WHERE HPO_PO_Number = DPO_PO_Number AND HPO_PO_Date >= @dtFromDate AND HPO_PO_Date <= @dtToDate
					AND HPO_DS_Code <> 8 AND HPO_Offer_Number = DCOFF_Offer_Number 
					AND HPO_Counter_Offer_Number = DCOFF_Counter_Offer_Number AND HPO_BA_Code = DCOFF_BA_Code
					AND DPO_Material_Code = DCOFF_Material_Code AND DPOCD_PO_Number = DPO_PO_Number 
					AND DPOCD_Amendment_Number = DPO_Amendment_Number AND DPOCD_Material_Code = DPO_Material_Code 
					AND MMAT_Material_Code = DPO_Material_Code AND MMAT_Company_Code = @intCompanyCode
					AND HPO_Company_Code = @intCompanyCode 	 and HPO_Last_Amendment_Number=DPO_Amendment_Number AND MMGRP_Company_Code ='1' and mmgrp_mg_code =MMAT_MG_CODE
										--AND ((@ChrConstZonApplicable = 'A') or 
										--		(@ChrConstZonApplicable = 'Y' and DPOCD_Rate_Applicable in ('Y','R')) or 
										--		(@ChrConstZonApplicable = 'N' and DPOCD_Rate_Applicable ='N'))

----------------------Amended PO

INSERT INTO #Temp_SCM_PO_Details
                (Temp_PO_Number, Temp_PO_Amendment_No, Temp_PO_Date, Temp_Job_Code, Temp_Vendor_Code, 
                Temp_Currency_Code, Temp_Material_Code,Temp_Material_Group ,Temp_Material_Group_Desc, Temp_PO_Basic_Rate,Temp_PO_Net_Rate, Temp_PO_Qty, Temp_PO_Value,
                Temp_Counter_Offer_Basic_Rate, Temp_ConstZon_Applicable, Temp_RC_Applicable,Temp_Constzon_skip_approval_required, Temp_National_Low_Rate,Temp_UOM,
				Temp_Created_By, Temp_Reason_for_Higher_Price,Temp_PO_POA)
		SELECT DISTINCT HPOAR_Request_Number, HPO_Last_Amendment_Number+1,
				 HPOAR_Request_Date, HPOAR_Job_Code, HPO_BA_Code, HPOAR_Currency_Code, DPOAR_Material_Code,MMAT_MG_CODE,MMGRP_Description,
 DPOAR_Basic_Rate,DPOAR_Net_Rate,DPOAR_Qty,DPOAR_Value,
				DCOFF_Basic_Rate, CASE WHEN DPOAC_Rate_Applicable IN ('Y','R') THEN 'Y' ELSE 'N' END, 
				   CASE WHEN DPOAC_Rate_Applicable IN ('R') THEN 'Y' ELSE 'N' END,DPOAC_WF_Skip_Approval_Required,
				   DPOAC_National_Low_Rate,MMAT_UOM_Code, HPOAR_Inserted_By, DPOAC_Remarks,SUBSTRING(hpoAR_REQUEST_number,6,3)
		FROM SQLSCM.SCM_H_Purchase_Orders, SQLSCM.SCM_H_PO_Amend_Request, SQLSCM.SCM_D_PO_Amend_Request,
					SQLSCM.SCM_D_Counter_Offer, SQLSCM.SCM_D_POA_ConstZon_Details,SQLMAS.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Groups 
		WHERE HPO_PO_Number = HPOAR_PO_Number AND HPOAR_Request_Number = DPOAR_Request_Number 
					AND HPOAR_Request_Date >= @dtFromDate AND HPOAR_Request_Date <= @dtToDate
					AND HPOAR_DS_Code <> 8 AND HPO_Offer_Number = DCOFF_Offer_Number AND HPO_BA_Code = DCOFF_BA_Code
					AND HPO_Counter_Offer_Number = DCOFF_Counter_Offer_Number AND DPOAR_Material_Code = DCOFF_Material_Code
					AND DPOAC_POA_Request_Number = DPOAR_Request_Number AND DPOAC_Amendment_Number = HPO_Last_Amendment_Number+1
					AND DPOAC_Material_Code = DPOAR_Material_Code AND MMAT_Material_Code = DPOAR_Material_Code
					AND MMAT_Company_Code= @intCompanyCode AND HPO_Company_Code = @intCompanyCode  AND MMGRP_Company_Code ='1' and mmgrp_mg_code =MMAT_MG_CODE
				 
								   -- AND ((@ChrConstZonApplicable = 'A') or 
											--(@ChrConstZonApplicable = 'Y' and DPOAC_Rate_Applicable in ('Y','R')) or 
											--(@ChrConstZonApplicable = 'N' and DPOAC_Rate_Applicable ='N'))

 
---------------Last PO Rate
				UPDATE #Temp_SCM_PO_Details SET Temp_Location_Code_PO = MAB_City_Code
				FROM #Temp_SCM_PO_Details, SQLMAS.Gen_M_Jobs, SQLMAS.GEN_M_Address_Book
				WHERE MJOB_Job_Code = Temp_Job_Code AND MJOB_AB_Code = MAB_AB_Code

				INSERT INTO #Temp_PO_Company_Rate (Temp_Material_Code, Temp_Currency_Code, Temp_Job_Location, LastPORate_Company)
				SELECT DPO_Material_Code, HPO_Currency_Code, MAB_City_Code, Max(DPO_Basic_Rate) 
						FROM SQLSCM.SCM_D_Purchase_Orders ,
								SQLSCM.SCM_H_Purchase_Orders, #Temp_SCM_PO_Details,
								SQLMAS.Gen_M_Jobs, SQLMAS.GEN_M_Address_Book
						WHERE  HPO_Company_Code = @intCompanyCode 
								AND HPO_PO_Number = DPO_PO_Number AND HPO_PO_DATE < @dtFromDate
								AND DPO_Material_Code = Temp_Material_Code AND HPO_Currency_Code = Temp_Currency_Code
								AND HPO_Company_Code = DPO_Company_Code AND HPO_DS_Code = 3 
								AND DPO_ISActive ='Y' AND DPO_DS_Code = 3
								AND MJOB_Job_Code = HPO_Job_Code AND MJOB_AB_Code = MAB_AB_Code
				GROUP BY  DPO_Material_Code, HPO_Currency_Code, MAB_City_Code

				UPDATE #Temp_SCM_PO_Details SET Temp_Last_PO_Rate_For_Location = b.LastPORate_Company
				FROM  #Temp_SCM_PO_Details a, #Temp_PO_Company_Rate b
				WHERE b.Temp_Material_Code = A.Temp_Material_Code AND a.Temp_Location_Code_PO = b.Temp_Job_Location
				AND a.Temp_Currency_Code = b.Temp_Currency_Code
				 

				SELECT b.Temp_Material_Code, b.Temp_Currency_Code, MAX(b.LastPORate_Company) LastPORate_Company INTO #TEMP_PORATE
				FROM  #Temp_SCM_PO_Details a, #Temp_PO_Company_Rate b
				WHERE  b.Temp_Material_Code = A.Temp_Material_Code AND a.Temp_Location_Code_PO <> b.Temp_Job_Location
                AND a.Temp_Currency_Code = b.Temp_Currency_Code
				GROUP BY b.Temp_Material_Code, b.Temp_Currency_Code
				 
				UPDATE #Temp_SCM_PO_Details SET Temp_Last_PO_Rate_From_Other_Location = c.LastPORate_Company, 
				Temp_Last_PO_Rate_From_Other_Location_Code_PO = b.Temp_Job_Location
				FROM  #Temp_SCM_PO_Details a, #Temp_PO_Company_Rate b, #TEMP_PORATE C
				WHERE  b.Temp_Material_Code = A.Temp_Material_Code AND a.Temp_Location_Code_PO <> b.Temp_Job_Location
                AND a.Temp_Currency_Code = b.Temp_Currency_Code and b.Temp_Material_Code = c.Temp_Material_Code
				and b.Temp_Currency_Code = c.Temp_Currency_Code and b.LastPORate_Company = c.LastPORate_Company 
					 
											 EXEC SQLBSS.#BSS_SP_Const_rate_updation
--UPDATE #Temp_SCM_PO_Details set Temp_Last_PO_Rate_For_Location= Temp_PO_Basic_Rate

--UPDATE #Temp_SCM_PO_Details set Temp_Last_PO_Rate_From_Other_Location= Temp_PO_Basic_Rate
 
--replace( replace( replace( replace( replace( replace( replace( replace(replace(MMAT_Material_Description,char(9),'-'),char(10),'-'),char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),'''','-'),'"','-'),',','-') descrip 



	 Update a set Temp_materialcategorycode  = d.LMMCLM_Material_Category_Code 
from #Temp_SCM_PO_Details a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Temp_Material_Code =LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code<>'9999'
	

 Update a set Temp_materialcategorycode = d.LMMCLM_Material_Category_Code 
from #Temp_SCM_PO_Details a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Temp_Material_Code =LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code='9999' and Temp_materialcategorycode is null
	

Update a set Temp_materialcategory = f.MMC_Description 
from #Temp_SCM_PO_Details a ,epm.sqlpmp.GEN_M_Material_Category f
where  Temp_materialcategorycode= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 

Update a set TEMP_EPM_Tag = TCM_EPM_Tag 
from #Temp_SCM_PO_Details a 

left join EPM.sqlepm.EPM_M_Control_Master b on Temp_Job_Code=TCM_Job_Code 



SELECT DISTINCT Temp_PO_Number PO_Number,Temp_PO_Amendment_No PO_Amendment_No, Temp_PO_Date PO_Date, 
						Temp_Job_Code Job_Code, 
						replace( replace( replace( replace( replace( replace( replace( replace(replace( MJOB_Description,char(9),'-'),char(10),'-'),char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),'''','-'),'"','-'),',','-')    MJOB_Description, 
						Temp_Location_Desc Location_Desc ,						
						 Temp_Material_Code Material_Code,Temp_Material_Group Material_Group,  
						 replace( replace( replace( replace( replace( replace( replace( replace(replace(Temp_Material_Group_Desc,char(9),'-'),char(10),'-'),char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),'''','-'),'"','-'),',','-') Material_Group_Desc,
						 replace( replace( replace( replace( replace( replace( replace( replace(replace(MMAT_Material_Description,char(9),'-'),char(10),'-'),char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),'''','-'),'"','-'),',','-') Material_Name, 
						Temp_ConstZon_Applicable ConstZon_Applicable, Temp_RC_Applicable RC_Applicable, 
						 Temp_Vendor_Code Vendor_Code, 
						 replace( replace( replace( replace( replace( replace( replace( replace(replace(MBA_BA_Name,char(9),'-'),char(10),'-'),char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),'''','-'),'"','-'),',','-') Vendor_Name, 
						Temp_materialcategorycode,
						Temp_materialcategory, 
						 MCUR_Description Currency, 
						 Temp_Counter_Offer_Basic_Rate Material_Counter_Offer_Basic_Rate, 
						Temp_PO_Basic_Rate PO_Material_Basic_Rate, Temp_PO_Net_Rate PO_Material_Net_Rate,	Temp_PO_Qty PO_Material_Qty,
						Temp_PO_Value	PO_Material_Value,				
						Temp_ConstZon_Lower_bound_Rate ConstZon_Lower_bound_Rate,
						Temp_ConstZon_Upper_bound_Rate ConstZon_Upper_bound_Rate, 
						Temp_Constzon_skip_approval_required Skip_level_approval_required,
						Temp_National_Low_Rate National_Low_Rate,
						Temp_Last_PO_Rate_For_Location Last_PO_Rate_For_Location, 		
						Temp_Last_PO_Rate_From_Other_Location Last_PO_Rate_From_Other_Location	, 
						MEMP_Employee_ID Creator_PSNo , MEMP_Name Created_By  , Temp_Reason_for_Higher_Price Reason_for_Higher_Price, TEMP_EPM_TAG EPM_TAG,
						case when Temp_ConstZon_Upper_bound_Rate is NULL then 'N' else 'Y' end as Rate_Available,
						Temp_PO_POA PO_POA
				
						FROM #Temp_SCM_PO_Details, SQLMAS.GEN_M_Materials,
						SQLMAS.GEN_M_Jobs, SQLMAS.GEN_M_Business_Associates,
						SQLMAS.GEN_M_Currencies, SQLMAS.GEN_M_Users, SQLMAS.GEN_M_Employees,
						SQLMAS.GEN_U_Cities
				where --Temp_PO_Basic_Rate <> Temp_Counter_Offer_Basic_Rate AND 
                Temp_Material_Code = MMAT_Material_Code and MMAT_Company_Code = @intCompanyCode
				 AND Temp_Job_Code = MJOB_Job_Code
				 AND Temp_Vendor_Code = MBA_BA_Code AND MBA_Company_Code = @intCompanyCode
				 AND Temp_Currency_Code = MCUR_Currency_Code
				 AND Temp_Created_By = MUSER_USER_ID AND MUSER_Company_Code = @intCompanyCode
				 AND MUSER_Reference_ID = MEMP_Employee_ID AND MEMP_Company_Code = @intCompanyCode
				 AND UCITY_City_Code = Temp_Last_PO_Rate_From_Other_Location_Code_PO
				 AND TEMP_EPM_TAG = 'N'
				
				 --AND Temp_ConstZon_Applicable in ('Y','R')

END
END



---------------Last PO Rate
 
 
				--Insert INTO #Temp_PO_Company_Rate
				--SELECT DPO_Material_Code, Max(DPO_Inserted_On) 
				--FROM SQLscm.scm_d_purchase_orders ,
				--SQLSCM.SCM_H_Purchase_Orders,#Temp_SCM_PO_Details
				--WHERE  HPO_Company_Code=@intCompanyCode
				--and exists (select top 1 'x' from #Temp_SCM_PO_Details where   dpo_material_code = Temp_Material_Code)
				--and Hpo_ds_code = 3 
				-- and dpo_isActive ='Y'	
				-- and HPO_PO_Number =DPO_PO_Number 			 
				--and HPO_Currency_Code = Temp_Currency_Code
				--and HPO_Company_Code = DPO_Company_Code
				--GROUP BY  DPO_Material_Code
								 
				--update #Temp_SCM_PO_Details SET Temp_Last_PO_Rate_For_Location = b.DPO_Net_Rate
				--from (SELECT  DPO_Material_Code, Max(dpo_net_rate) DPO_Net_Rate
				--FROM SQLscm.scm_d_purchase_orders ,
				--SQLSCM.SCM_H_Purchase_Orders a
				--WHERE  HPO_Company_Code=@intCompanyCode
				--and HPO_PO_Number =DPO_PO_Number 
				--and HPO_Currency_Code = 72
				--and HPO_Company_Code = DPO_Company_Code
				--and Hpo_ds_code = 3 
				-- and dpo_isActive ='Y'
				--and exists (select top 1 'x' from #Temp_PO_Company_Rate Where  Temp_Material_Code = DPO_Material_Code AND Temp_DPO_Inserted_On = DPO_Inserted_On AND DPO_Company_Code=@intCompanyCode)
				--GROUP BY DPO_Material_Code) as b
				--Where     b.DPO_Material_Code=Temp_Material_Code


GO
 
--delete from #Temp_SCM_PO_Details
/*
select * from #Temp_SCM_PO_Details
drop table #Temp_SCM_PO_Details
CREATE TABLE #Temp_SCM_PO_Details
(
                        Temp_PO_Number VARCHAR(30),
                        Temp_PO_Amendment_No Int,
                        Temp_PO_Date     DATE,
                        Temp_Job_Code    VarChar(15),
                        Temp_Vendor_Code    VarChar(15),
                        Temp_Currency_Code   Int,
                        Temp_Location_Code Int,
                        Temp_Material_Code VARCHAR(30),
                        Temp_ConstZon_Applicable Char(1),
                        Temp_RC_Applicable Char(1),
                        Temp_Counter_Offer_Basic_Rate Money,
                        Temp_PO_Basic_Rate          Money,
                        Temp_National_Low_Rate Money,
                        Temp_ConstZon_Lower_bound_Rate Money,
                        Temp_ConstZon_Upper_bound_Rate Money,
                        Temp_Last_PO_Rate_For_Location Money,
                        Temp_Last_PO_Rate_From_Other_Location Money,
                        Temp_UOM Int,
                                         Temp_Location_desc varchar(500)
)

Insert into  #Temp_SCM_PO_Details
select 'po13',1,getdate()-2,'mbbh7533','adfsd',72,null,'102000215',null,null,23,323,12,2,3,12,23,331,null union
select 'po134',2,getdate()-2,'UBBO0001','adfsd',72,null,'102000505',null,null,23,323,12,2,3,12,23,331,null union
select 'po135',3,getdate()-2,'LE150005','adfsd',72,null,'102092007',null,null,23,323,12,2,3,12,23,331 ,null
*/
create PROCEDURE #BSS_SP_Const_rate_updation
(
@Error VARCHAR(100)=null OUTPUT
)
AS
/*
Created By : Jeyanthi.J
Created On : 26-Feb-2018
Purpose: To Update Constzon Reference Price for the Item

	declare @Error VARCHAR(100)
	Exec #BSS_SP_Const_rate_updation 
	select @Error
*/

Declare @Cnt int, @i int, @jobcode varchar(15), @itemcode varchar(15), @UOM INT,@Currency INT
Declare @CityCode int, @CityDesc varchar(100),@StateCode int, @StateDesc varchar(100),@ZoneCode int

IF OBJECT_ID('tempdb..#Temp_SCM_PO_Details','u') IS NULL      
BEGIN
SET @Error = 'No Data Exists'
END
ELSE
BEGIN
SELECT DISTINCT Temp_job_code,Temp_location_code,Temp_Material_Code INTO #temp_JOB FROM #Temp_SCM_PO_Details  where Temp_ConstZon_Applicable ='Y'
ALTER TABLE #temp_JOB ADD slno int Identity

Select @Cnt =Count(*) from #temp_JOB
SET @i =1

While @i<=@Cnt
Begin
       Select @jobcode =Temp_job_code from #temp_JOB where slno=@i
       Select @itemCode =Temp_Material_Code from #temp_JOB where slno=@i

       Select TOP 1 @StateCode = Mab.MAB_State_Code,@StateDesc = GUS.USTAT_Name,@CityCode = mab.MAB_City_Code,@CityDesc = GUC.UCITY_Name
                                         FROM Eip.Sqlmas.Gen_M_Jobs MJ 
                     Left Join Eip.Sqlmas.Gen_L_Job_Cluster_Elements JCE on (MJ.Mjob_Job_Code = JCE.LJCE_Job_Code)
                     Left Join eip.sqlmas.GEN_M_Address_Book  MAB on ( MJ.Mjob_AB_Code=Mab.MAB_AB_Code)
                     Left Join Eip.Sqlmas.GEN_U_Cities GUC on (Mab.MAB_City_Code=GUC.UCITY_City_Code)
                     Left Join eip.sqlmas.GEN_U_States GUS on (GUC.UCITY_State_Code = GUS.USTAT_State_Code )                                 
          Where Mjob_Job_Code = @JobCode
                 
       --  select @StateDesc,@CityDesc
                IF NOT EXISTS ( Select 'X' from  sqlbss.BSS_M_RA_Location Where MRALO_Location_Code = @CityCode and MRALO_IsApplicable ='Y' and exists
				(select 'x' from sqlbss.BSS_T_Rate_Analysis c where  BTRA_EIP_Item_Code = @itemCode AND BTRA_Location_Code = MRALO_Location_code ) )
           BEGIN      
                            IF  EXISTS ( select 'X' from sqlbss.BSS_M_RA_Location,EIP.[SQLBSS].[BSS_L_RA_ZONE_CITY] where LRAZC_CITY_CODE = MRALO_Location_Code AND LRAZC_STATE_CODE = @StateCode and  MRALO_IsApplicable ='Y' 
							and exists	(select 'x' from sqlbss.BSS_T_Rate_Analysis c where  BTRA_EIP_Item_Code = @itemCode AND BTRA_Location_Code = MRALO_Location_code ))
                         BEGIN   
					--	 select 'state',@JobCode
                                             /*state code checking*/                                                                     
                                                select  TOP 1 @CityCode = LRAZC_CITY_CODE from sqlbss.BSS_M_RA_Location,EIP.[SQLBSS].[BSS_L_RA_ZONE_CITY] 
												where  LRAZC_CITY_CODE = MRALO_Location_Code AND LRAZC_STATE_CODE = @StateCode 
                                              AND EXISTS (select 'x' from sqlbss.BSS_M_RA_Location c where  MRALO_Location_Code = LRAZC_CITY_CODE and  MRALO_IsApplicable ='Y' ) 
											  AND EXISTS (select 'x' from sqlbss.BSS_T_Rate_Analysis c where  BTRA_EIP_Item_Code = @itemCode AND BTRA_Location_Code = MRALO_Location_code )
                        END
                                         Else IF  EXISTS(select 'X' from sqlbss.BSS_M_RA_Location,EIP.sqlmas.gen_m_cluster_element_details,eip.sqlmas.GEN_L_Job_Cluster_Elements  
                                                  where ljce_job_code=@jobCode AND LJCE_Location_code=mcled_ced_code and  mcled_description = MRALO_description and   MRALO_IsApplicable ='Y' 
                                                              AND EXISTS (select 'x' from sqlbss.BSS_T_Rate_Analysis c where  BTRA_EIP_Item_Code = @itemCode AND BTRA_Location_Code = MRALO_Location_code ))
                        BEGIN   
                           /*Location checking*/               
						--   select  'Location'  ,@JobCode                                                                                   
                          select  TOP 1 @CityCode = MRALO_Location_code from sqlbss.BSS_M_RA_Location,EIP.sqlmas.gen_m_cluster_element_details,eip.sqlmas.GEN_L_Job_Cluster_Elements 
                                     where ljce_job_code= @jobCode  AND LJCE_Location_code=mcled_ced_code and  mcled_description = MRALO_description and   MRALO_IsApplicable ='Y' 
                            AND EXISTS (select 'x' from sqlbss.BSS_T_Rate_Analysis c where  BTRA_EIP_Item_Code = @itemCode AND BTRA_Location_Code = MRALO_Location_code )  

                         END                                         
                               Else                          
                           BEGIN
                                    IF EXISTS(SELECT 'x' FROM EIP.[SQLBSS].[BSS_L_RA_ZONE_CITY] WHERE LRAZC_CITY_CODE = @CityCode AND LRAZC_STATE_CODE = @StateCode
									AND EXISTS (select 'x' from sqlbss.BSS_T_Rate_Analysis c where  BTRA_EIP_Item_Code = @itemCode AND BTRA_Location_Code = LRAZC_CITY_CODE))
                                    BEGIN
                                    /* zone code checking */
						--			  select 'zone'  ,@JobCode 
                       SELECT TOP 1 @ZoneCode = LRAZC_ZONE_CODE FROM EIP.[SQLBSS].[BSS_L_RA_ZONE_CITY] WHERE LRAZC_CITY_CODE = @CityCode AND LRAZC_STATE_CODE = @StateCode
                       SELECT TOP 1 @CityCode = LRAZC_CITY_CODE FROM EIP.[SQLBSS].[BSS_L_RA_ZONE_CITY] WHERE LRAZC_ZONE_CODE = @ZoneCode
                        and exists (select 'x' from sqlbss.BSS_M_RA_Location c where  MRALO_Location_Code = LRAZC_CITY_CODE and  MRALO_IsApplicable ='Y')   
						AND EXISTS (select 'x' from sqlbss.BSS_T_Rate_Analysis c where  BTRA_EIP_Item_Code = @itemCode AND BTRA_Location_Code = LRAZC_CITY_CODE)
                                   END
                                  ELSE
                                     BEGIN
								--	 select 'else'  ,@JobCode 
                                      SELECT TOP 1 @CityCode = MRALO_Location_Code FROM EIP.[SQLBSS].[BSS_M_RA_Location] WHERE MRALO_IsApplicable ='Y' 
									  AND EXISTS (select 'x' from sqlbss.BSS_T_Rate_Analysis c where  BTRA_EIP_Item_Code = @itemCode AND BTRA_Location_Code = MRALO_Location_Code)
                                      END
                                                     
                                   END
          END 

		--  select @CityCode

                Update #temp_JOB set Temp_Location_Code =@CityCode  FROM #temp_JOB Where  slno=@i         
                
SET @i=@i+1

End          
Update #Temp_SCM_PO_Details set Temp_Location_Code =c.Temp_Location_Code, Temp_Location_Desc =MRALO_Description,Temp_ConstZon_Lower_bound_Rate =btra_overall_minimum_range, Temp_ConstZon_Upper_bound_Rate =btra_overall_maximum_range
FROM #Temp_SCM_PO_Details a,  #temp_JOB c,  sqlbss.BSS_M_RA_Location, sqlbss.BSS_T_Rate_Analysis
Where a.temp_job_code=C.temp_job_code and c.Temp_Location_Code =MRALO_Location_code  and Temp_ConstZon_Applicable ='Y'
and a.Temp_Material_Code =c.Temp_Material_Code and BTRA_EIP_ITEM_CODE =c.Temp_Material_Code and c.Temp_Location_Code =BTRA_Location_Code 
				

				   
                
--Update #Temp_SCM_PO_Details set Temp_Location_Code =c.Temp_Location_Code, Temp_ConstZon_Lower_bound_Rate =btra_overall_minimum_range, Temp_ConstZon_Upper_bound_Rate =btra_overall_maximum_range
--FROM #Temp_SCM_PO_Details a, sqlbss.BSS_T_Rate_Analysis b , #temp_JOB c
--Where a.temp_job_code=C.temp_job_code and c.Temp_Location_Code =BTRA_Location_code and a.Temp_Material_Code =BTRA_EIP_Item_code and Temp_Currency_Code   =BTRA_Currency and 
--Temp_UOM =BTRA_Item_UOM  and Temp_ConstZon_Applicable ='Y'
                

END










GO
 
