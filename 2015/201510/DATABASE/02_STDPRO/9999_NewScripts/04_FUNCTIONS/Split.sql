IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Split]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Split]
GO

/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 07/05/2012 10:57:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Split]
(    
    @RowData NVARCHAR(MAX),
    @Delimeter NVARCHAR(MAX)
)
RETURNS @RtnValue TABLE 
(
    ID INT IDENTITY(1,1),
    Data NVARCHAR(MAX)
) 
AS
BEGIN 
    DECLARE @Iterator INT
    SET @Iterator = 1

    DECLARE @FoundIndex INT
    SET @FoundIndex = CHARINDEX(@Delimeter,@RowData)

    WHILE (@FoundIndex>0)
    BEGIN
        INSERT INTO @RtnValue (data)
        SELECT 
            Data = SUBSTRING(@RowData, 1, @FoundIndex - 1)

        SET @RowData = SUBSTRING(@RowData,
                @FoundIndex + DATALENGTH(@Delimeter) / 2,
                LEN(@RowData))

        SET @Iterator = @Iterator + 1
        SET @FoundIndex = CHARINDEX(@Delimeter, @RowData)
    END
    
    INSERT INTO @RtnValue (Data)
    SELECT Data = @RowData

    RETURN
END
GO


