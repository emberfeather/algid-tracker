<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="list" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset i18n = variables.transport.applicationSingletons.getI18N() />
		<cfset datagrid = variables.transport.applicationTransients.getDatagrid(i18n, variables.transport.locale) />
		
		<cfset datagrid.addColumn({
				key = 'timestamp',
				label = 'Time'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'ipAddress',
				label = 'IP Address'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'userID',
				label = 'User ID'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'plugin',
				label = 'Plugin'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'key',
				label = 'Key'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'details',
				label = 'Details'
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>