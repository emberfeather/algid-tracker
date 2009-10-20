<cfset viewEvent = application.factories.transient.getViewEventForTracker( transport ) />

<cfset filter = {
	} />

<cfset events = servEvent.readEvents( filter ) />

<cfoutput>#viewEvent.list( events )#</cfoutput>