/****** Object:  StoredProcedure [dbo].[AP2027]    Script Date: 08/05/2010 09:34:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/



--Creater : Nguyen Thi Thuy Tuyen
---Creadate:16/06/2006
-- Puppose :Lay du lieu don hang  do ra combo cho man hinh xuat  kho   !
-- Edit By ThuyTuyen 8/08/2007 
--Edit: Thuy Tuyen, date 26/11/2009. Them truong VoucherTypeID

ALTER PROCEDURE [dbo].[AP2027]
       @DivisionID nvarchar(50) ,
       @VoucherDate datetime ,
       @OrderID nvarchar(50)
AS
DECLARE @sSQL nvarchar(4000)

-- Xu ly tao bang bang tam ---
IF EXISTS ( SELECT
                *
            FROM
                dbo.sysobjects
            WHERE
                id = object_id(N'[dbo].[OT1013]') AND OBJECTPROPERTY(id , N'IsUserTable') = 1 )
   BEGIN
         DROP TABLE [dbo].[OT1013]
   END

CREATE TABLE [dbo].[OT1013]
(
  [DivisionID] [nvarchar](50) NULL ,
  [OrderID] [nvarchar](50) NULL ,
  [VoucherNo] [nvarchar](50) NULL ,
  [OrderDate] [datetime] NULL ,
  [OrderStatus] [tinyint] NULL ,
  [ObjectID] [nvarchar](50) NULL ,
  [ObjectName] [nvarchar](250) NULL ,
  [Notes] [nvarchar](250) NULL ,
  [TranMonth] [int] NULL ,
  [TranYear] [int] NULL ,
  [OrderType] [tinyint] NULL ,
  [ContractNo] [nvarchar](50) NULL ,
  [PaymentID] [nvarchar](50) NULL ,
  [Disabled] [tinyint] NULL ,
  [Address] [nvarchar](250) NULL ,
  [Type] [nvarchar](50) NULL ,
  [VoucherTypeID] [nvarchar](50) NULL )
ON     [PRIMARY]




INSERT
    OT1013
    (
      DivisionID ,
      OrderID ,
      VoucherNo ,
      OrderDate ,
      OrderStatus ,
      ObjectID ,
      ObjectName ,
      Notes ,
      TranMonth ,
      TranYear ,
      OrderType ,
      ContractNo ,
      PaymentID ,
      Disabled ,
      Address ,
      Type ,
      VoucherTypeID )
    SELECT
        T00.DivisionID ,
        SOrderID AS OrderID ,
        VoucherNo ,
        OrderDate ,
        T00.OrderStatus ,
        T00.ObjectID ,
        T01.ObjectName ,
        Notes ,
        T00.TranMonth ,
        T00.TranYear ,
        T00.OrderType ,
        T00.ContractNo ,
        T00.PaymentID ,
        T00.Disabled ,
        T00.DeliveryAddress AS Address ,
        'SO' AS Type ,
        VoucherTypeID
    FROM
        OT2001 T00 LEFT JOIN AT1202 T01
    ON  T00.ObjectID = T01.ObjectID
        AND T00.DivisionID = T01.DivisionID
    WHERE
        OrderStatus NOT IN ( 0 , 9 ) AND T00.Disabled = 0 --- not in (0, 3, 4, 9) 
        AND T00.DivisionID = @DivisionID

    UNION ALL
    SELECT
        T00.DivisionID ,
        POrderID AS OrderID ,
        VoucherNo ,
        OrderDate ,
        T00.OrderStatus ,
        T00.ObjectID ,
        T01.ObjectName ,
        Notes ,
        T00.TranMonth ,
        T00.TranYear ,
        T00.OrderType ,
        ContractNo ,
        '''' AS PaymentID ,
        T00.Disabled ,
        T00.ReceivedAddress AS Address ,
        'PO' AS Type ,
        VoucherTypeID
    FROM
        OT3001 T00 LEFT JOIN AT1202 T01
    ON  T00.ObjectID = T01.ObjectID
        AND T00.DivisionID = T01.DivisionID
    WHERE
        OrderStatus NOT IN ( 0 , 9 ) AND T00.Disabled = 0  ----not in (0, 3, 4, 9)
        AND T00.DivisionID = @DivisionID

    UNION
    SELECT
        T00.DivisionID ,
        QuotationID AS OrderID ,
        QuotationNo ,
        QuotationDate ,
        T00.OrderStatus ,
        T00.ObjectID ,
        T01.ObjectName ,
        Description AS Notes ,
        T00.TranMonth ,
        T00.TranYear ,
        0 AS OrderType ,
        '' AS ContractNo ,
        T00.PaymentID ,
        T00.Disabled ,
        T00.DeliveryAddress AS Address ,
        'QU' AS Type ,
        VoucherTypeID
    FROM
        OT2101 T00 LEFT JOIN AT1202 T01
    ON  T00.ObjectID = T01.ObjectID
        AND T00.DivisionID = T01.DivisionID
    WHERE
        OrderStatus NOT IN ( 2 , 3 , 9 ) AND T00.Disabled = 0 AND QuotationID NOT IN ( SELECT DISTINCT
                                                                                           isnull(QuotationID , '')
                                                                                       FROM
                                                                                           OT2001 ) --- not in (0, 3, 4, 9) 
        AND T00.DivisionID = @DivisionID

    UNION  --Don hang hieu chinh
    SELECT
        T00.DivisionID ,
        VoucherID AS OrderID ,
        VoucherNo ,
        VoucherDate ,
        T00.OrderStatus ,
        T00.ObjectID ,
        T01.ObjectName ,
        Description AS Notes ,
        T00.TranMonth ,
        T00.TranYear ,
        0 AS OrderType ,
        '' AS ContractNo ,
        '' AS PaymentID ,
        T00.Disabled ,
        T00.DeliveryAddress AS Address ,
        'AS' AS Type ,
        VoucherTypeID
    FROM
        OT2006 T00 LEFT JOIN AT1202 T01
    ON  T00.ObjectID = T01.ObjectID
        AND T00.DivisionID = T01.DivisionID
    WHERE
        OrderStatus NOT IN ( 2 , 3 , 9 ) AND T00.Disabled = 0 --- not in (0, 3, 4, 9) 
        AND T00.DivisionID = @DivisionID

    UNION ---Yeu cau donhang mua
    SELECT
        T00.DivisionID ,
        ROrderID AS OrderID ,
        VoucherNo ,
        OrderDate AS VoucherDate ,
        T00.OrderStatus ,
        T00.ObjectID ,
        T01.ObjectName ,
        Description AS Notes ,
        T00.TranMonth ,
        T00.TranYear ,
        0 AS OrderType ,
        T00.ContractNo ,
        T00.PaymentID ,
        T00.Disabled ,
        T00.ReceivedAddress AS Address ,
        'RO' AS Type ,
        VoucherTypeID
    FROM
        OT3101 T00 LEFT JOIN AT1202 T01
    ON  T00.ObjectID = T01.ObjectID
        AND T00.DivisionID = T01.DivisionID
    WHERE
        OrderStatus NOT IN ( 0 , 9 ) AND T00.Disabled = 0  ----and ROrderID not in (Select Distinct isnull(RequestID, '')  From OT3001) ----not in (0, 3, 4, 9)
        AND T00.DivisionID = @DivisionID


-------

IF isnull(@OrderID , '') = ''
   BEGIN
         SET @sSQL = ' 
 Select  	DivisionID, OrderID,
	 VoucherNo, 
	 OrderDate, 
	ObjectName, 
	Notes ,
	Type,
	VoucherTypeID
  From   OT1013
 Where  Type  = ''SO'' and
	OrderStatus not in (0,3,4,5,9) and 
	Disabled =0 and    OrderType  in (0,1)  and DivisionID = ''' + @DivisionID + ''' and 
	OrderID in (Select  Distinct OV1013.OrderID From OV1013  Where  EndQuantity >0 	and DivisionID =''' + @DivisionID + '''  )
 
Union
Select 		DivisionID, OrderID,
		 VoucherNo,
		OrderDate,
		ObjectName,
		Notes,
		Type , VoucherTypeID
From      OT1013 
Where   Type  =  ''AS'' and 
	OrderStatus not in (0,9)  and 
	OrderDate<= ''' + CONVERT(varchar(10) , @VoucherDate , 101) + ''' and DivisionID =  ''' + @DivisionID + ''' And 
	OrderID in (Select 	Distinct OrderID 
		     From OV1016 
		      Where DataType=2 and OrderQuantity > 0)'
   END
ELSE
   BEGIN
         SET @sSQL = '
Select  	DivisionID , OrderID,
	 VoucherNo, 
	 OrderDate, 
	ObjectName, 
	Notes ,
	Type,VoucherTypeID
  From   OT1013
 Where  Type  = ''SO'' and
	OrderStatus not in (0,3,4,5,9) and 
	Disabled =0 and    OrderType in (0,1) and DivisionID = ''' + @DivisionID + ''' and 
	OrderID in (Select  Distinct OV1013.OrderID From OV1013  Where  EndQuantity >0 	and DivisionID =''' + @DivisionID + '''  )

Union all
	Select  DivisionID, OrderID, VoucherNo,  OrderDate, ObjectName, Notes ,Type ,VoucherTypeID
	From OT1013 
	Where Type =''SO'' and  OrderStatus not in (0,3,4,5,9) 
	and Disabled =0 and  DivisionID = ''' + @DivisionID + ''' and OrderID = ''' + @OrderID + '''  
Union
Select 		DivisionID, OrderID,
		 VoucherNo,
		OrderDate,
		ObjectName,
		Notes,
		Type ,VoucherTypeID
From      OT1013 
Where   Type  =  ''AS'' and 
	OrderStatus not in (0,9)  and 
	OrderDate<= ''' + CONVERT(varchar(10) , @VoucherDate , 101) + ''' and DivisionID =  ''' + @DivisionID + ''' And 
	OrderID in (Select 	Distinct OrderID 
		     From OV1016 
		      Where DataType=2 and OrderQuantity > 0)'
   END

 	
----Print @sSQL
IF NOT EXISTS ( SELECT
                    1
                FROM
                    sysObjects
                WHERE
                    Xtype = 'V' AND Name = 'AV2026' )
   BEGIN
         EXEC ( ' Create view AV2026 as '+@sSQL )
   END
ELSE
   BEGIN
         EXEC ( ' Alter view AV2026 as '+@sSQL )
   END