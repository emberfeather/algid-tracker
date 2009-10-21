<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="filter" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filter = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filter = variables.transport.applicationTransients.getFilter(variables.transport.requestSingletons.getUrl()) />
		
		<!--- Search --->
		<cfset filter.addFilter('Search', 'search') />
		
		<!--- Timeframes --->
		<cfset options = variables.transport.applicationTransients.getOptions() />
		
		<cfset options.addOption('All Available', '') />
		<cfset options.addOption('Past Day', 'day') />
		<cfset options.addOption('Past Week', 'week') />
		<cfset options.addOption('Past Month', 'month') />
		<cfset options.addOption('Past Quarter', 'quarter') />
		<cfset options.addOption('Past Year', 'year') />
		
		<cfset filter.addFilter('Timeframe', 'timeframe', options) />
		
		<cfreturn filter.toHTML() />
	</cffunction>
	
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