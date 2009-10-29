<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="filter" access="public" returntype="string" output="false">
		<cfargument name="pluginKeys" type="query" required="true" />
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filter = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filter = variables.transport.applicationTransients.getFilter(variables.transport.applicationSingletons.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filter.addI18NBundle('plugins/tracker/i18n/inc/view', 'viewEvent') />
		
		<!--- Search --->
		<cfset filter.addFilter('search') />
		
		<!--- Timeframes --->
		<cfset options = variables.transport.applicationTransients.getOptions() />
		
		<cfset options.addOption('All Available', '') />
		<cfset options.addOption('Past Day', 'day') />
		<cfset options.addOption('Past Week', 'week') />
		<cfset options.addOption('Past Month', 'month') />
		<cfset options.addOption('Past Quarter', 'quarter') />
		<cfset options.addOption('Past Year', 'year') />
		
		<cfset filter.addFilter('timeframe', options) />
		
		<!--- Plugin --->
		<cfquery name="results" dbtype="query">
			SELECT DISTINCT plugin
			FROM arguments.pluginKeys
			ORDER BY plugin ASC
		</cfquery>
		
		<cfset options = variables.transport.applicationTransients.getOptions() />
		
		<cfset options.addOption('All Plugins', '') />
		
		<cfloop query="results">
			<cfset options.addOption(results.plugin, results.plugin) />
		</cfloop>
		
		<cfset filter.addFilter('plugin', options) />
		
		<cfreturn filter.toHTML(variables.transport.requestSingletons.getURL()) />
	</cffunction>
	
	<cffunction name="list" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset i18n = variables.transport.applicationSingletons.getI18N() />
		<cfset datagrid = variables.transport.applicationTransients.getDatagrid(i18n, variables.transport.locale) />
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addI18NBundle('plugins/tracker/i18n/inc/view', 'viewEvent') />
		
		<cfset datagrid.addColumn({
				key = 'timestamp',
				label = 'timestamp'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'ipAddress',
				label = 'ipAddress'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'userID',
				label = 'user'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'plugin',
				label = 'plugin'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'key',
				label = 'key'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'details',
				label = 'details'
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>