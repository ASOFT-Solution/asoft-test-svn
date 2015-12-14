IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DToKhaiKHBS]') AND type in (N'U'))
BEGIN
	SET ANSI_NULLS ON
	
	SET QUOTED_IDENTIFIER ON
	
	CREATE TABLE [dbo].[DToKhaiKHBS](
		[DToKhaiKHBSID] [uniqueidentifier] NOT NULL,
		[MToKhaiID] [uniqueidentifier] NOT NULL,
		[SortOrder] [int] NOT NULL,
		[TargetTypeID] [nvarchar](512) NOT NULL,
		[TargetName] [nvarchar](512) NULL,
		[TargetID] [nvarchar](512) NULL,
		[TargetReturn] [decimal](28, 6) NULL,
		[TargetAmended] [decimal](28, 6) NULL,
		[TargetDifference] [decimal](28, 6) NULL,
	 CONSTRAINT [PK_DToKhaiKHBS] PRIMARY KEY CLUSTERED 
	(
		[DToKhaiKHBSID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	
	ALTER TABLE [dbo].[DToKhaiKHBS]  WITH CHECK ADD  CONSTRAINT [FK_DToKhaiKHBS_MToKhai2] FOREIGN KEY([MToKhaiID])
	REFERENCES [dbo].[MToKhai] ([MToKhaiID])
	
	ALTER TABLE [dbo].[DToKhaiKHBS] CHECK CONSTRAINT [FK_DToKhaiKHBS_MToKhai2]	
END