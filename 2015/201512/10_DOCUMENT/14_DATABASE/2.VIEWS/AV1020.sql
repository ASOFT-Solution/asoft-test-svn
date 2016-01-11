IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AV1020]'))
DROP VIEW [dbo].[AV1020]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- View để in thông tin hợp đồng

CREATE VIEW [dbo].[AV1020] AS

SELECT 
AT1020.DivisionID,
AT1020.ContractID,
AT1020.VoucherTypeID,
AT1020.ContractNo,
AT1020.SignDate,
AT1020.CurrencyID,
AT1020.ContractName,
AT1020.ObjectID,
AT1202.ObjectName,
AT1020.ContractType,
AT1020.Amount,
AT1020.ConRef01,
AT1020.ConRef02,
AT1020.ConRef03,
AT1020.ConRef04,
AT1020.ConRef05,
AT1020.ConRef06,
AT1020.ConRef07,
AT1020.ConRef08,
AT1020.ConRef09,
AT1020.ConRef10,
AT1020.Description,
AT1021.ContractDetailID,
AT1021.StepID,
AT1021.StepName,
AT1021.StepDays,
AT1021.PaymentPercent,
AT1021.PaymentAmount,
AT1021.StepStatus,
AT1021.CompleteDate,
AT1021.PaymentDate,
AT1021.CorrectDate,
AT1021.PaymentStatus,
AT1021.Notes      
FROM AT1020
INNER JOIN AT1021 ON AT1021.DivisionID = AT1020.DivisionID AND AT1021.ContractID = AT1020.ContractID
INNER JOIN AT1202 ON AT1202.DivisionID = AT1020.DivisionID AND AT1202.ObjectID = AT1020.ObjectID
GO


