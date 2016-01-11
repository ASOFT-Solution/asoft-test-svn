
/****** Object:  StoredProcedure [dbo].[HP5020]    Script Date: 08/05/2010 10:01:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
----Created by: Vo Thanh Huong, date: 25/02/2004
----purpose:  Tinh thue thu nhap doanh nghiep

ALTER PROCEDURE [dbo].[HP5020]
       @DivisionID varchar(20) ,
       @TranMonth int ,
       @TranYear int ,
       @TaxObjectID varchar(20) ,
       @PayrollmethodD varchar(20)
AS /*

If @MethodID = 0 ---luy tien
	Begin
		Set @SalaryAmount = isnull((Select Sum(Amount*(Case When (@Quantity> FromValues and @Quantity <= Tovalues  ) 
						then @Quantity - FromValues
				  Else Case When (@Quantity<= FromValues) then 0 
					Else Tovalues - FromValues  end end))
					From HT1016 
					Where ProductID = @ProductID and ToValues <>-1) ,0)

	
		Set @SalaryAmount = @SalaryAmount + isnull((select Sum(Amount*(@Quantity - FromValues))
				 From HT1016
				 Where ProductID =@ProductID and ToValues =-1 and FromValues < @Quantity  ),0)
		
	End
Else

If @MethodID = 1
	Begin
		Set @UnitPrice =  isnull( (Select Amount From HT1016 Where ProductID = @ProductID and
										FromValues<= @Quantity and ( ToValues >@Quantity or ToValues =-1) ),0)
		Set 	@SalaryAmount = 	@UnitPrice*@Quantity						
								
	End

*/


