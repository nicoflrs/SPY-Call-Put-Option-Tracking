USE [money]
GO

/****** Object:  StoredProcedure [dbo].[sp_SPYCallData]    Script Date: 10/27/2021 1:25:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [dbo].[sp_SPYCallData]
AS


--IF OBJECT_ID(N'money..[SPYcallData]') IS NOT NULL
--delete from money..[SPYcallData]

IF OBJECT_ID(N'tempdb..#APITemp1') IS NOT NULL
DROP TABLE #APITemp1

IF OBJECT_ID(N'tempdb..#APITemp2') IS NOT NULL
DROP TABLE #APITemp2

IF OBJECT_ID(N'tempdb..#calldata1') IS NOT NULL
DROP TABLE #calldata1

IF OBJECT_ID(N'tempdb..#calldata2') IS NOT NULL
DROP TABLE #calldata2

IF OBJECT_ID(N'tempdb..#calldata3') IS NOT NULL
DROP TABLE #calldata3

EXEC sp_configure 'show advanced options', 1
RECONFIGURE

EXEC sp_configure 'Ole Automation Procedures', 1
RECONFIGURE

DECLARE @token INT;
DECLARE @ret INT;
DECLARE @url NVARCHAR(MAX);
DECLARE @authHeader NVARCHAR(64);
DECLARE @contentType NVARCHAR(64);
DECLARE @json AS TABLE(Json_Table NVARCHAR(MAX))

SET @url = 'https://api.tdameritrade.com/v1/marketdata/chains?apikey=ULVKWUX1NGVL7IA3J0SFTBZ4JRDFJB1V&symbol=SPY&contractType=ALL&includeQuotes=TRUE&strategy=SINGLE'

EXEC @ret = sp_OACreate 'MSXML2.XMLHTTP', @token OUT;
IF @ret <> 0 RAISERROR('Unable to open HTTP connection.', 10, 1);

EXEC @ret = sp_OAMethod @token, 'open', NULL, 'GET', @url, 'false';
EXEC @ret = sp_OAMethod @token, 'send'

INSERT into @json (Json_Table) EXEC sp_OAGetProperty @token, 'responseText'

select [underlying].value as 'Ticker', [call_Series_Date].[key] as 'ExpirationDate', [OptionData].[key] as 'Strike', [OptionData3].* 
into #APITemp1
FROM OPENJSON((SELECT * FROM @json))
WITH (callExpDateMap NVARCHAR(MAX) AS JSON, underlying NVARCHAR(MAX) AS JSON) AS  MetaData
CROSS APPLY OPENJSON([MetaData].[underlying]) AS underlying
CROSS APPLY OPENJSON([MetaData].[callExpDateMap]) AS call_Series_Date
CROSS APPLY OPENJSON([call_Series_Date].[value]) AS OptionData
CROSS APPLY OPENJSON([OptionData].[value]) AS OptionData2 
CROSS APPLY OPENJSON([OptionData2].[value]) AS OptionData3

select 
Ticker
,ExpirationDate	
,Strike	
,[key]
,value
into #APITemp2
from #APITemp1
where ticker = 'SPY'


select 
	Ticker
	,expirationdate
	,strike
	,[key]
	,value
	,'expirationdate' + cast(ROW_NUMBER() over (Partition By strike order by expirationdate, strike) as Varchar(10)) as 'ColumnSequence'
	into #calldata1
	from #APITemp2
	order by 2 asc
Select 
Ticker
,expirationdate as Expiry
,strike
,expirationdate1 as putCall
,expirationdate2 as symbol
,expirationdate3 as description
,expirationdate4
,expirationdate5
,expirationdate6
,expirationdate7
,expirationdate8
,expirationdate9
,expirationdate10
,expirationdate11
,expirationdate12
,expirationdate13
,expirationdate14
,expirationdate15
,expirationdate16
,expirationdate17 as totalVolume
,expirationdate18
,expirationdate19
,expirationdate20
,expirationdate21
,expirationdate22
,expirationdate23
,expirationdate24
,expirationdate25
,expirationdate26
,expirationdate27
,expirationdate28 as openInterest
,expirationdate29
,expirationdate30
,expirationdate31
,expirationdate32
,expirationdate33
,expirationdate34
,expirationdate35 as daysToExpiration
,expirationdate36
,expirationdate37
,expirationdate38
,expirationdate39
,expirationdate40
,expirationdate41
,expirationdate42
,expirationdate43
,expirationdate44
,expirationdate45
,expirationdate46
,expirationdate47
into #calldata2
From
#calldata1
	PIVOT
(MAX(value)
	For ColumnSequence in (expirationdate1
	,expirationdate2
	,expirationdate3
	,expirationdate4
	,expirationdate5
	,expirationdate6
	,expirationdate7
	,expirationdate8
	,expirationdate9
	,expirationdate10
	,expirationdate11
	,expirationdate12
	,expirationdate13
	,expirationdate14
	,expirationdate15
	,expirationdate16
	,expirationdate17
	,expirationdate18
	,expirationdate19
	,expirationdate20
	,expirationdate21
	,expirationdate22
	,expirationdate23
	,expirationdate24
	,expirationdate25
	,expirationdate26
	,expirationdate27
	,expirationdate28
	,expirationdate29
	,expirationdate30
	,expirationdate31
	,expirationdate32
	,expirationdate33
	,expirationdate34
	,expirationdate35
	,expirationdate36
	,expirationdate37
	,expirationdate38
	,expirationdate39
	,expirationdate40
	,expirationdate41
	,expirationdate42
	,expirationdate43
	,expirationdate44
	,expirationdate45
	,expirationdate46
	,expirationdate47)
) PIV
where 
expirationdate1 is not null
OR expirationdate2 is not null
OR expirationdate3 is not null
OR expirationdate4 is not null
OR expirationdate5 is not null
OR expirationdate6 is not null
OR expirationdate7 is not null
OR expirationdate8 is not null
OR expirationdate9 is not null
OR expirationdate10 is not null
OR expirationdate11 is not null
OR expirationdate12 is not null
OR expirationdate13 is not null
OR expirationdate14 is not null
OR expirationdate15 is not null
OR expirationdate16 is not null
OR expirationdate17 is not null
OR expirationdate18 is not null
OR expirationdate19 is not null
OR expirationdate20 is not null
OR expirationdate21 is not null
OR expirationdate22 is not null
OR expirationdate23 is not null
OR expirationdate24 is not null
OR expirationdate25 is not null
OR expirationdate26 is not null
OR expirationdate27 is not null
OR expirationdate28 is not null
OR expirationdate29 is not null
OR expirationdate30 is not null
OR expirationdate31 is not null
OR expirationdate32 is not null
OR expirationdate33 is not null
OR expirationdate34 is not null
OR expirationdate35 is not null
OR expirationdate36 is not null
OR expirationdate37 is not null
OR expirationdate38 is not null
OR expirationdate39 is not null
OR expirationdate40 is not null
OR expirationdate41 is not null
OR expirationdate42 is not null
OR expirationdate43 is not null
OR expirationdate44 is not null
OR expirationdate45 is not null
OR expirationdate46 is not null
OR expirationdate47 is not null

select Strike
,Expiry
,min(putCall)  as putCall
,min(symbol)  as symbol
--,min(description)  as description
--,min(expirationdate4)  as exchangeName
--,min(expirationdate5) as bid
--,min(expirationdate6)  as ask
--,min(expirationdate7)  as last
--,min(expirationdate8)  as mark
--,min(expirationdate9)  as bidSize
--,min(expirationdate10) as askSize
--,min(expirationdate11) as bidAskSize
--,min(expirationdate12) as lastSize
--,min(expirationdate13) as highPrice
--,min(expirationdate14) as lowPrice
--,min(expirationdate15) as openPrice
--,min(expirationdate16) as closePrice
,min(totalVolume) as totalVolume
--,min(expirationdate18) as tradeDate
--,min(expirationdate19) as tradeTimeInLong
--,min(expirationdate20) as quoteTimeInLong
--,min(expirationdate21) as netChange
--,min(expirationdate22) as volatility
--,min(expirationdate23) as delta
--,min(expirationdate24) as gamma
--,min(expirationdate25) as theta
--,min(expirationdate26) as vega
--,min(expirationdate27) as rho
,min(openInterest) as openInterest
--,min(expirationdate29) as timeValue
--,min(expirationdate30) as theoreticalOptionValue
--,min(expirationdate31) as theoreticalVolatility
--,min(expirationdate32) as optionDeliverablesList
--,min(expirationdate33) as strikePrice
--,min(expirationdate34) as expirationDate
,min(daysToExpiration) as daysToExpiration
--,min(expirationdate36) as expirationType
--,min(expirationdate37) as lastTradingDay
--,min(expirationdate38) as multiplier
--,min(expirationdate39) as settlementType
--,min(expirationdate40) as deliverableNote
--,min(expirationdate41) as isIndexOption
--,min(expirationdate42) as percentChange
--,min(expirationdate43) as markChange
--,min(expirationdate44) as markPercentChange
--,min(expirationdate45) as nonStandard
--,min(expirationdate46) as inTheMoney
--,min(expirationdate47) as mini
,getdate() as UpdatedDate
into #calldata3
from #calldata2
group by Strike, Expiry
order by 2 asc

insert into money.dbo.[SPYcallData]
select *
from #calldata3
where daysToExpiration in ('0', '1')


GO


