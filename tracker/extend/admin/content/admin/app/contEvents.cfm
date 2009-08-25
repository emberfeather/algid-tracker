<cfset viewEvent = createObject('component', 'plugins.tracker.inc.view.viewEvent').init( theURL ) />

<cfset filter = {
	} />

<cfset events = servEvent.readEvents( filter ) />

<cfoutput>#viewEvent.list( events, filter )#</cfoutput>