

-- Factorial Function

--Create a scalar-valued function that returns the factorial of a number you gave it.



CREATE FUNCTION dbo.GetFactorial(@num INT)
RETURNS INT
AS
BEGIN
    DECLARE @result INT = 1;
    DECLARE @i INT = 1;

    WHILE @i <= @num
    BEGIN
        SET @result = @result * @i;
        SET @i = @i + 1;
    END

    RETURN @result;
END;


SELECT dbo.GetFactorial(4) AS Factorial;   