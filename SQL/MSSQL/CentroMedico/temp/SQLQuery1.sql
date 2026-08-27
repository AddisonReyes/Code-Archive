USE [CentroMedico]
GO

/****** Object:  Table [dbo].[Paciente]    Script Date: 7/14/2026 10:59:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Paciente](
	[IdPaciente] [dbo].[idPaciente] IDENTITY(1,1) NOT NULL,
	[Cedula] [nvarchar](20) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Apellido] [nvarchar](50) NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[Domicilio] [nvarchar](50) NOT NULL,
	[IdPais] [dbo].[idPais] NOT NULL,
	[Telefono] [nvarchar](20) NULL,
	[Email] [nvarchar](255) NOT NULL,
	[Observacion] [dbo].[observacion] NULL,
 CONSTRAINT [PK_Paciente] PRIMARY KEY CLUSTERED 
(
	[IdPaciente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Paciente]  WITH CHECK ADD  CONSTRAINT [FK_Paciente_Pais] FOREIGN KEY([IdPais])
REFERENCES [dbo].[Pais] ([IdPais])
GO

ALTER TABLE [dbo].[Paciente] CHECK CONSTRAINT [FK_Paciente_Pais]
GO


