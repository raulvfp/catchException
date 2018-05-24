 */
 * @since:  1.0
 *
 * @author: Raúl Juárez <raul.jrz@gmail.com>
 * @date: 2018.05.15;21.00
 */
DEFINE CLASS test_catchException as FxuTestCase OF FxuTestCase.prg
*----------------------------------------------------------------------

	#IF .f.
	LOCAL THIS AS test_catchException OF test_catchException.PRG
	#ENDIF
	oObject      = ''  &&Este es el objecto que va a ser evaluado
	oldPath      = ''
	oldProcedure = ''
	oldDefault   = ''

	*--------------------------------------------------------------------
	FUNCTION Setup
	* Configuración base de todos los Test de esta clase
	*--------------------------------------------------------------------
		*SET PATH TO E:\Shared\Project\librery\catchException
		THIS.oldPath     =SET('PATH')
		THIS.oldProcedure=SET('PROCEDURE')
		THIS.oldDefault  =SET('DEFAULT')
		*THIS.MessageOut('Procedures: '+SET("PROCEDURE"))
		*THIS.MessageOut('Path......: '+SET("PATH"))
		*THIS.MessageOut('Default...: '+SET("DEFAULT"))
		*THIS.MessageOut('============================================================')

		SET PROCEDURE TO (ADDBS(SYS(5)+CURDIR())+'src\catchException.prg') ADDITIVE
		SET PATH TO (THIS.oldPath +";"+ADDBS(SYS(5)+CURDIR())+'src ')
		THIS.MessageOut('Procedures: '+STRTRAN(SET("PROCEDURE"),";",CHR(13)+SPACE(12)))
		THIS.MessageOut('Path......: '+STRTRAN(SET("PATH"),";",CHR(13)+SPACE(12)))
		THIS.MessageOut('Default...: '+SET("DEFAULT"))
		THIS.MessageOut('============================================================')
		THIS.MessageOut('')
		 *THIS.oObject = CREATEOBJECT('catchException')
	ENDFUNC
	
	*---------------------------------------------------------------------
	FUNCTION testCatch_Exception()
	* Verifica que se lance el objeto que controla la excepcion
	*---------------------------------------------------------------------
		TRY 
			*--- Este es una excepcion y que lanza el CATCH para controlarla
			lnStatus = lcNoExisteLaVariable
 
		CATCH TO loEx
			loTmp = CREATEOBJECT('catchException', .F.)
			
			THIS.MessageOut('Esto me indica si es un error o algo generador por el programador: ' +loEx.Message)
			THIS.MessageOut('Valor de userValue: '+loEx.UserValue)
		ENDTRY

		THIS.AssertNotNull('No existe el objecto',loEx)

	ENDFUNC

	*--------------------------------------------------------------------
	FUNCTION TearDown
	* Restaura el estado anterior del ambiente de desarrollo
	*--------------------------------------------------------------------
		SET PATH TO      (THIS.oldPath)
		SET PROCEDURE TO (THIS.oldProcedure)
		SET DEFAULT TO   (THIS.oldDefault)
	ENDFUNC

	*--------------------------------------------------------------------
	FUNCTION test_GenerounExecptionThrow
	* Note: Pruebo la generacion de Exceptiones con THROW
	*--------------------------------------------------------------------
		LOCAL lcExpectedValue, lcFileLog
		lcExpectedValue = 'My_Exception'
		lcFileLog = 'error.log'            && Es el archivo de salida con el log de la Exception
		
		IF FILE(lcFileLog) THEN
			DELETE FILE (lcFileLog)
		ENDIF
		TRY 
			*--- Este es una excepcion generada con THROW
			THROW lcExpectedValue 
 
		CATCH TO loEx
			loTmp = CREATEOBJECT('catchException', .F.)
			
			THIS.MessageOut('Esto me indica si es un error o algo generador por el programador: ' +loEx.Message)
			THIS.MessageOut('Valor de userValue: '+loEx.UserValue)
		ENDTRY

		THIS.AssertNotNull('No existe el objecto',loEx)
		THIS.AssertEquals(lcExpectedValue, loEx.UserValue, 'ERROR, se experaba otro valor')
		
		THIS.AssertTrue(FILE(lcFileLog), 'Error, no se encontro el archivo log: '+lcFileLog)
	ENDFUNC


ENDDEFINE
*----------------------------------------------------------------------
* The three base class methods to call from your test methods are:
*
* THIS.AssertTrue	    (<Expression>, "Failure message")
* THIS.AssertEquals	    (<ExpectedValue>, <Expression>, "Failure message")
* THIS.AssertNotNull	(<Expression>, "Failure message")
* THIS.MessageOut       (<Expression>)
*
* Test methods (through their assertions) either pass or fail.
*----------------------------------------------------------------------

* AssertNotNullOrEmpty() example.
*------------------------------
*FUNCTION TestObjectWasCreated
*   THIS.AssertNotNullOrEmpty(THIS.oObjectToBeTested, "Test Object was not created")
*ENDFUNC
