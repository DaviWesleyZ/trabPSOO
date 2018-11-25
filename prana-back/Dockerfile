FROM docker.iscinternal.com:5000/2018.1.0/isc-idp:2018.1.0.289.0

LABEL maintainer "davihwrz@hotmail.com"
ARG ISC_PACKAGE_USER_PASSWORD
ARG ISC_PACKAGE_CSPSYSTEM_PASSWORD
ENV TMP_INSTALL_DIR="/tmp/install" \
 ISC_DATA_DIRECTORY="/data/docker/SYS/IDP2017" \
 InstallScript="install.scr" \
 InstallFile="Util/Build.cls" \
 AppDir="." \
 AppName="prana" 
WORKDIR $TMP_INSTALL_DIR

COPY $AppDir $TMP_INSTALL_DIR/$AppDir

COPY cache.key* Dockerfile $ISC_PACKAGE_INSTALLDIR/mgr/
RUN : Define permissão no diretorio para escrita && \
	chmod -R a+rx $TMP_INSTALL_DIR && \
	: Cria e instala script. First, precisamos enviar o usuário e senha para autenticar && \
	echo _SYSTEM >$InstallScript && \
	echo $ISC_PACKAGE_USER_PASSWORD >>$InstallScript && \
	: Agora, carregar e compilar a classe construida && \
	echo do \$system.OBJ.Load\(\"$TMP_INSTALL_DIR/$AppDir/$InstallFile\",\"ck\"\) >>$InstallScript && \
	: Executa metodo construido && \
	echo do \#\#class\(Util.Build\).Build\(\"$AppName\",\"$TMP_INSTALL_DIR/$AppDir\",\"/opt/$AppName\"\) >>$InstallScript && \
	: Run data population utility && \
	echo zn \"$AppName\" >>$InstallScript && \
	echo do \#\#class\(Data.PopulateWidgets\).Populate\(\) >>$InstallScript && \
	: Set up Dispatch Class for REST application && \
	echo zn \"%SYS\" >>$InstallScript && \
	echo set a=\#\#class\(Security.Applications\).%OpenId\(\"/widgetsdirect/rest\"\) >>$InstallScript && \
	echo set a.DispatchClass=\"REST.Dispatch\" >>$InstallScript && \
	echo do a.MatchRoles.Insert\(\":%DB_%DEFAULT\"\) >>$InstallScript && \
	echo write a.%Save\(\) >>$InstallScript && \
	echo set a=\#\#class\(Security.Applications\).%OpenId\(\"/widgetsdirect\"\) >>$InstallScript && \
	echo do a.MatchRoles.Insert\(\":%DB_%DEFAULT\"\) >>$InstallScript && \
	echo write a.%Save\(\) >>$InstallScript && \
	: add a record into install log && \
	echo set ^installLog\(\$i\(^installLog\)\)=\$zdt\(\$h,3\) >>$InstallScript && \
	echo zwrite imported >>$InstallScript && \
	: Finish the process && \
	echo halt >>$InstallScript && \
	: Now start Cache and run the script && \
	ccontrol start $ISC_PACKAGE_INSTANCENAME && \
	csession $ISC_PACKAGE_INSTANCENAME < $InstallScript && \
	ccontrol stop $ISC_PACKAGE_INSTANCENAME quietly && \
	: Copy CSP and JS files to correct directory && \
	mkdir /opt/$AppName/web && \
	cp -r $TMP_INSTALL_DIR/$AppDir/CSP/$AppName/* /opt/$AppName/csp/. && \
	: Delete temp files && \
 	rm -rf ${TMP_INSTALL_DIR}/* 

# O Container pode ser executado pelas portas:
EXPOSE 57772 1972 22 443 80
ENTRYPOINT ["/ccontainermain"]