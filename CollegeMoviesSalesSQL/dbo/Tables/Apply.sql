CREATE TABLE [dbo].[Apply] (
    [sID]      FLOAT (53)     NULL,
    [cName]    NVARCHAR (255) NULL,
    [major]    NVARCHAR (255) NULL,
    [decision] NVARCHAR (255) NULL,
    UNIQUE NONCLUSTERED ([sID] ASC, [cName] ASC, [major] ASC)
);

