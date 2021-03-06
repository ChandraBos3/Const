`SELECT * from epm.sqlpmp.GEN_L_MATERIAL_CATEGORY_MATERIAL_GROUP where  LMCMG_MG_Code ='6e64'      

select *from eip.sqlmas.GEN_M_Material_Groups where  MMGRP_Company_Code ='1' and mmgrp_mg_code like '%6c11%'
select *from eip.sqlmas.GEN_M_item_Groups where MiGRP_Company_Code ='1' migrp_item_group_code like '%6c11%'
drop table #temp   
select distinct MSR_Resource_Group_Code, msrp_description,MSR_Resource_Code into #temp 
from epm.sqlpmp.Gen_M_Standard_Resource, epm.sqlpmp.Gen_M_Standard_Resource_Group , devserver.EIP.SQLBSS.BSS_T_Rate_Analysis
where MSR_Resource_Group_Code=MSRP_Resource_Group_Code and btra_eip_item_code=MSR_Resource_Code 
and MSR_Resource_Type_Code ='SCPL' and 
 MSRP_Resource_Type_Code=MSR_Resource_Type_Code 
---and MSR_Resource_Group_Code like'%6C13%'

--select * from #temp 
select MSR_Resource_Group_Code, msrp_description, count(*)
from #temp group by MSR_Resource_Group_Code, msrp_description

select *From epm.sqlpmp.Gen_M_Standard_Resource_Group  where MSRP_Resource_Group_Code like '%6eb2%'
select *From epm.sqlpmp.Gen_M_Standard_Resource  where MSR_Resource_Group_Code like '%6C26%'and MSR_Resource_Type_Code ='SCPL' and MSR_IsActive='y'

select *From epm.sqlpmp.Gen_M_Standard_Resource  where MSR_Resource_Type_Code ='SCPL' 

select *From epm.sqlpmp.Gen_M_Standard_Resource  where MSR_Resource_Code ='6O12S009P' 

select btra_eip_item_code,MMAT_Material_Description,mmgrp_description,BTRA_Location_Code,MRALO_Description,mralo_isapplicable,btra_item_uom, uuom_description, btra_overall_minimum_range, btra_overall_maximum_range,BTRA_BenchMark_Rate,BTRA_Rate_Contract_Applicable, BTRA_RC_ATTCH_TAG,BTRA_ISACTIVE
from sqlbss.bss_t_rate_analysis a
join sqlbss.bss_m_ra_location on (BTRA_Location_Code =MRALO_Location_Code)
Left join sqlmas.gen_m_materials on (mmat_material_code=btra_eip_item_code)
Left join sqlmas.gen_u_unit_of_measurement on (btra_item_uom=UUOM_UOM_Code)
Left join sqlmas.gen_m_material_groups on (MMGRP_MG_Code=MMAT_MG_Code)
where btra_item_type =1 and BTRA_Location_Code =MRALO_Location_Code and MMAT_Company_Code=1 

select *from EIP.sqlmas.gen_m_materials where MMAT_Material_Code = '610805304' and mmat_company_code ='1'


select *from eip.sqlbss.BSS_T_Expert_Validation 

select distinct btra_eip_item_code from eip.sqlbss.BSS_T_Rate_Analysis where  BTRA_Company_Code='1' and btra_isactive ='y'  and BTRA_Item_Type ='1'


and len (BTRA_EIP_ITEM_CODE) >= '15'
select *from eip.sqlbss.BSS_T_Rate_Analysis where BTRA_eip_Item_code like '%6c1h%'


select *from eip.sqlbss.BSS_T_Rate_Analysis where BTRA_eip_Item_code  like '%6c12s00np%' 

select *from eip.sqlbss.BSS_T_Rate_Analysis_history where BTRAh_eip_Item_code LIKE '%6c12s00np%'

drop table #rm
select BTRA_eip_Item_code,btra_location_code,btra_item_uom,BTRA_Recommended_Minimum_Range,	BTRA_Recommended_Maximum_Range,	BTRA_BenchMark_Rate,mmgrp_mg_code,mmgrp_description,btra_isactive,mmat_isactive into #rm from eip.sqlbss.BSS_T_Rate_Analysis, eip.sqlmas.GEN_M_Material_Groups,EIP.sqlmas.gen_m_materials where  BTRA_Company_Code='1'  and BTRA_Item_Type ='1'

and mmat_material_code = BTRA_eip_Item_code  and mmat_mg_Code = MMGRP_MG_Code and mmat_company_code ='1'
and MMGRP_Company_Code= mmat_company_code 
and btra_isactive ='y'

alter table #rm add materialcategory2 VARCHAR (500)
alter table #rm add PlanningCategory2 VARCHAR (500)

 Update a set materialcategory2 = d.LMCMG_Material_Category_Code 
from #rm a , epm.sqlpmp.GEN_L_MATERIAL_CATEGORY_MATERIAL_GROUP d
where mmgrp_mg_Code=LMcmg_mg_Code 

Update a set PlanningCategory2 = f.MMC_Description 
from #rm a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategory2= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 
  

  select *from #rm
Select  Mab.MAB_State_Code, GUS.USTAT_Name,mab.MAB_City_Code, GUC.UCITY_Name
       FROM Eip.Sqlmas.Gen_M_Jobs MJ 
       Left Join Eip.Sqlmas.Gen_L_Job_Cluster_Elements JCE on (MJ.Mjob_Job_Code = JCE.LJCE_Job_Code)
       Left Join eip.sqlmas.GEN_M_Address_Book  MAB on ( MJ.Mjob_AB_Code=Mab.MAB_AB_Code)
       Left Join Eip.Sqlmas.GEN_U_Cities GUC on (Mab.MAB_City_Code=GUC.UCITY_City_Code)
       Left Join eip.sqlmas.GEN_U_States GUS on (GUC.UCITY_State_Code = GUS.USTAT_State_Code )                                 
       Where Mjob_Job_Code = 'LE160975'


drop table #temp1
	   select distinct MSR_Resource_Group_Code, msrp_description,MSR_Resource_Code into #temp1 
from epm.sqlpmp.Gen_M_Standard_Resource, epm.sqlpmp.Gen_M_Standard_Resource_Group , devserver.EIP.SQLBSS.BSS_T_Rate_Analysis
where MSR_Resource_Group_Code=MSRP_Resource_Group_Code and btra_eip_item_code=MSR_Resource_Code 
and MSR_Resource_Type_Code ='matr' and 
 MSRP_Resource_Type_Code=MSR_Resource_Type_Code 
 --and MSR_Resource_Group_Code ='6c2a'

--select * from #temp
select MSR_Resource_Group_Code, msrp_description, count(*)
from #temp1 group by MSR_Resource_Group_Code, msrp_description


SELECT *FROM epm.sqlpmp.Gen_M_Standard_Resource_Group where MSRP_RESOURCE_GROUP_CODE ='6C1S'


drop table #temp2
	   select distinct MSR_Resource_Group_Code, msrp_description,MSR_Resource_Code into #temp2
from epm.sqlpmp.Gen_M_Standard_Resource, epm.sqlpmp.Gen_M_Standard_Resource_Group 
where MSR_Resource_Group_Code=MSRP_Resource_Group_Code 
and MSR_Resource_Type_Code ='matr' and 
 MSRP_Resource_Type_Code=MSR_Resource_Type_Code 
 --and MSR_Resource_Group_Code ='6E15S001T'
 and MSR_IsActive='y'

--select * from #temp2 WHERE MSR_RESOURCE_CODE like '%6c28%'
select MSR_Resource_Group_Code, msrp_description, count(*)
from #temp2 group by MSR_Resource_Group_Code, msrp_description

select *from eip.sqlbss.BSS_M_RA_Location

SELECT *FROM epm.sqlpmp.Gen_M_Standard_Resource WHERE LEN ( MSR_Resource_Code) = '11'
SELECT *FROM epm.sqlpmp.Gen_M_Standard_Resource WHERE MSR_Resource_Code = '6C11S000G'

select *from EPM.SQLPMP.Gen_M_Standard_Resource,eip.sqlmas.GEN_M_item_Groups where msr_resource_type_code = 'scpl' and MSR_Resource_Group_Code = MIGRP_item_group_code and MIGRP_Company_code ='1'

select *from eip.sqlwom.wom_m_job_item_codes where mjitc_company_code ='1' and mjitc_isactive ='n'

select *from eip.sqlmas.GEN_M_Material_Classes where MMATC_Company_Code ='1'

SELECT *FROM eip.sqlmas.GEN_M_item_Groups WHERE MIGRP_ITEM_GROUP_CODE LIKE '%6O12%'
       
Select  Mab.MAB_State_Code, GUS.USTAT_Name,mab.MAB_City_Code, GUC.UCITY_Name
       FROM Eip.Sqlmas.Gen_M_Jobs MJ 
       Left Join Eip.Sqlmas.Gen_L_Job_Cluster_Elements JCE on (MJ.Mjob_Job_Code = JCE.LJCE_Job_Code)
       Left Join eip.sqlmas.GEN_M_Address_Book  MAB on ( MJ.Mjob_AB_Code=Mab.MAB_AB_Code)
       Left Join Eip.Sqlmas.GEN_U_Cities GUC on (Mab.MAB_City_Code=GUC.UCITY_City_Code)
       Left Join eip.sqlmas.GEN_U_States GUS on (GUC.UCITY_State_Code = GUS.USTAT_State_Code )                                 
       Where Mjob_Job_Code is NULL




drop table #temp	   
select distinct MSR_Resource_Group_Code, msrp_description,MSR_Resource_Code into #temp 
from epm.sqlpmp.Gen_M_Standard_Resource, epm.sqlpmp.Gen_M_Standard_Resource_Group , devserver.EIP.SQLBSS.BSS_T_Rate_Analysis
where MSR_Resource_Group_Code=MSRP_Resource_Group_Code and btra_eip_item_code=MSR_Resource_Code 
and MSR_Resource_Type_Code ='matr' and 
 MSRP_Resource_Type_Code=MSR_Resource_Type_Code 
 --and MSR_Resource_Group_Code ='6c2a'

--select * from #temp
select MSR_Resource_Group_Code, msrp_description, count(*)
from #temp group by MSR_Resource_Group_Code, msrp_description


drop table #temp3
	   select distinct MSR_Resource_Group_Code, msrp_description,MSR_Resource_Code into #temp3
from epm.sqlpmp.Gen_M_Standard_Resource, epm.sqlpmp.Gen_M_Standard_Resource_Group,devserver.EIP.SQLBSS.BSS_T_Rate_Analysis 
where MSR_Resource_Group_Code=MSRP_Resource_Group_Code and btra_eip_item_code=MSR_Resource_Code 
and MSR_Resource_Type_Code ='scpl' and 
 MSRP_Resource_Type_Code=MSR_Resource_Type_Code 
 --and MSR_Resource_Group_Code ='6c2a'
 and MSR_IsActive='y'

--select * from #temp
select MSR_Resource_Group_Code, msrp_description, count(*)
from #temp3 group by MSR_Resource_Group_Code, msrp_description




use Eip
go

select * from INFORMATION_SCHEMA.COLUMNS 
where COLUMN_NAME like '%rate%' 
order by TABLE_NAME



select DPO_Net_Rate, DPO_Basic_Rate, a.HPO_Offer_Number,* from eip.sqlscm.SCM_H_Purchase_Orders a, eip.sqlscm.SCM_D_Purchase_Orders,eip.sqlscm.SCM_D_PO_ConstZon_Details,
eip.sqlscm.SCM_T_Document_Approvals
where HPO_PO_Number = DPO_PO_Number 
and a.HPO_Company_Code=1
and a.HPO_DS_Code='3'
and a.HPO_PO_Number= DPOCD_PO_Number and DPOCD_Amendment_Number = DPO_Amendment_Number
and DPOCD_WF_Skip_Approval_Required='Y'
and TSCDA_Document_Reference_Number = a.HPO_PO_Number and TSCDA_Amendment_Number= DPO_Amendment_Number
and TSCDA_DS_Code=13
--and (TSCDA_Remarks like '%prices%' or TSCDA_Remarks like '%Const%' or TSCDA_Remarks  like '%negotiate%')
and DPO_ISActive='Y'
and a.HPO_PO_Number='E5037PO8000022'

select * from eip.sqlscm.SCM_d_Counter_Offer where DCOFF_Offer_Number='E0858OFR8000015'
and DCOFF_Material_Code in ('311610104','312402160')

select *from eip.sqlscm.SCM_T_Document_Approvals where TSCDA_Document_Reference_Number = 'E2222PO8000712'


select *From lnt.dbo.vendor_master where vendor_code = 'V0045525'


select *from eip.sqlmas.GEN_M_Material_Groups where MMGRP_Company_Code ='1' and MMGRP_MG_Code like '%6c11%'

select *from epm.sqlpmp.Gen_M_Standard_Resource_Group where msrp_resource_type_code = 'MATR' AND MSRP_ISACTIVE = 'Y'

select *from LNT.dbo.sector_master

select *from lnt.dbo.job_master where company_code='HE'     

select *from epm.sqlpmp.GEN_L_MATERIAL_CATEGORY_MATERIAL_GROUP

select *from epm.sqlpmp.GEN_M_Material_Category where mmc_company_code ='1' and mmc_

USE EIP

GO


SELECT *FROM SYS.TABLES WHERE NAME LIKE '%rate%'
SELECT *FROM EIP.SQLMAS.GEN_M_Companies       

SELECT *FROM LNT.DBO.Company_Master   




select *from eip.sqlscm.SCM_H_Purchase_Orders where HPO_PO_NUMBER ='EC174PO8000496' AND DPO_MATERIAL_CODE = '320290626'
    

select *from eip.sqlmas.GEN_M_Materials where mmat_material_code IN ('6EB1M00DA000000','6CD2M000V000000','6EB1M00AN000000','6EB1M00BE000000','6CD2M0002000000','6CD1M0053000000','315080640','315080320','6E21M0001000005','384602100','6CH2M0003000000','6CO1M0002000002','323199014','323199979','327010080','6E51M0006000000','6CD1M000A000000','6C11M000A000000','359942010','315091103','6CG1M0010000000','6CG1M001K000000','6EB1M009M000000','6C11M0008000000','6CL1M0086000000','315055480','6EB1M00AF000000','6EB1M00BC000000','6E42M0001000000','6CL1M0090000000','6CL1M00DM000000','6CH1M002V000000','6CL1M00IQ000000','6CL1M00IR000000','6CL1M00IS000000','6C92M0001000000','6CL1M00B8000000','6CL1M00B9000000','6CL1M00D3000000','6CL1M00D4000000','6CL1M00D5000000','6CL1M00FW000000','6CL1M006H000000','359920600','598503010','598503020','6CL1M00AM000000','388046030','6EB1M00BZ000000','6CD1M0021000000','6CD1M0027000000','315055320','228070130','6E51M0002000000','6E51M0003000002','6E51M000Q000000','6EB1M0048000000','6EB1M0053000000','6M21M007P000001','6M21M00R7000000','6M21M00R9000000','6CL1M008G000000','6CL1M008J000000','6CL1M008H000000','6CL1M008I000000','6CD1M003H000000','6EB1M0052000000','6EB1M00B2000000','6CL1M008A000000','6CD2M000F000000','389027200','369090015','6M21M00BN000001','6EB1M006L000000')
AND MMAT_Company_Code='1'
select *from EIP.SQLMAS.GEN_M_ITEM_GROUPS

select *from EPM.sqlmas.Standard_workorder_major_work

select *from eip.SQLSCM.SCM_D_PO_ConstZon_Details where dpocd_po_number = 'EH633PO8000029'

USE EIP
GO

select *from eip.sqlscm.SCM_D_Purchase_Orders WHERE DPO_PO_NUMBER = 'EE606PO7000122'
select *from eip.sqlscm.SCM_H_Purchase_Orders WHERE HPO_PO_NUMBER = 'EH633PO8000029'
select SUM(hpo_native_currency_value) from eip.sqlscm.SCM_H_Purchase_Orders where hpo_company_code ='1' and hpo_ds_code= '3'
select *from eip.sqlscm.SCM_H_Material_Request where hmr_mr_number ='EA317EMR8000117'

use eip

go

select *from sys.tables where name like '%VEHICLE%'

select *from eip.sqlmas.GEN_M_Materials where mmat_material_code = '395521280' AND MMAT_Company_Code='1'

select *from eip.sqlscm.SCM_D_Purchase_Orders WHERE DPO_RC_BASED= 'Y' AND DPO_ISACTIVE ='Y'

select *from lnt.dbo.vehicles_master

select *from lnt.dbo.job_master where job_code ='LE180162'

SELECT *FROM eip.SQLWOM.WOM_H_Work_Orders


  select *  into #temp3
from epm.sqlpmp.Gen_M_Standard_Resource, epm.sqlpmp.Gen_M_Standard_Resource_Group 
where MSR_Resource_Group_Code=MSRP_Resource_Group_Code 
and MSR_Resource_Type_Code ='scpl' and 
 MSRP_Resource_Type_Code=MSR_Resource_Type_Code 
 --and MSR_Resource_Group_Code ='6E15S001T'
 and MSR_IsActive='y'

 ALTER TABLE #temp3 add category varchar (500)
 alter table #temp3 add MJITC_ISACTIVE varchar (50)

 UPDATE A SET a.category = MIGRP_Description  FROM #temp3 a, epm.sqlpmp.GEN_M_Item_Groups b
where MIGRP_Item_Group_Code = left(msr_resource_code,4)

UPDATE A SET A.MJITC_IsActive = B.MJITC_ISACTIVE FROM #temp3 a,eip.sqlwom.wom_m_job_item_codes B
WHERE MJITC_Item_Code= msr_resource_code
and MJITC_Company_Code=1
and B.MJITC_IsActive ='Y'





select *from #temp3

select distinct hpo_po_number from eip.sqlscm.SCM_H_Purchase_Orders WHERE HPO_ds_code ='3' and hpo_company_code ='1' 
and hpo_po_date between '01-Jul-2018' and '31-Jul-2018'

select distinct DPOCD_PO_Number from eip.sqlscm.SCM_D_PO_ConstZon_Details where dpocd_company_code ='1' and dpocd_inserted_on between '01-Jul-2018' and '31-Jul-2018'




select * from eip.sqlwom.wom_m_job_item_codes where mjitc_job_code = 'LE160815' AND MJITC_ITEM_Code = '6C11S005E'

select * from eip.


select *from  eip.sqlacs.ACS_T_Document_Flow where tdf_document_code = 'E4338WOD7000027'

select *from eip.sqlmas.GEN_M_Document_Transaction

select *from eip.SQLWOM.WOM_H_Work_Order_Request where hworq_request_number ='E4338WOR8000024'

select *from eip.sqlscm.SCM_T_Document_Approvals

SELECT *FROM eip.sqlmas.gen_m_users 
--where MUSER_USER_ID_OLD ='20111730'
where muser_reference_id = '20111730'

SELECT *FROM EIP.SQLMAS.GEN_M_Employees WHERE memp_company_code ='1' and memp_isacti

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  