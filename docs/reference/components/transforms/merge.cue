package metadata

components: transforms: merge: {
	title:             "Merge"
	short_description: "Accepts log events and allows you to merge partial log events into a single event."

	classes: {
		commonly_used: false
		development:   "beta"
		egress_method: "stream"
		function:      "aggregate"
	}

	features: {}

	support: {
		platforms: {
			"aarch64-unknown-linux-gnu":  true
			"aarch64-unknown-linux-musl": true
			"x86_64-apple-darwin":        true
			"x86_64-pc-windows-msv":      true
			"x86_64-unknown-linux-gnu":   true
			"x86_64-unknown-linux-musl":  true
		}

		requirements: []
		warnings: []
		notices: []
	}

	configuration: {
		fields: {
			common: true
			description: """
				Fields to merge.
				The values of these fields will be merged into the first partial event.
				Fields not specified here will be ignored.
				Merging process takes the first partial event and the base, then it merges in the fields from each successive partial event, until a non-partial event arrives.
				Finally, the non-partial event fields are merged in, producing the resulting merged event.
				"""
			required: false
			warnings: []
			type: array: {
				default: ["message"]
				items: type: string: examples: ["message", "parent.child"]
			}
		}
		partial_event_marker_field: {
			common: true
			description: """
				The field that indicates that the event is partial.
				A consequent stream of partial events along with the first non-partial event will be merged together.
				"""
			required: false
			warnings: []
			type: string: {
				default: "_partial"
				examples: ["_partial", "parent.child"]
			}
		}
		stream_discriminant_fields: {
			common: true
			description: """
				An ordered list of fields to distinguish streams by.
				Each stream has a separate partial event merging state.
				Should be used to prevent events from unrelated sources from mixing together, as this affects partial event processing.
				"""
			required: false
			warnings: []
			type: array: {
				default: []
				items: type: string: examples: ["host", "parent.child"]
			}
		}
	}

	input: {
		logs:    true
		metrics: false
	}

	examples: [
		{
			title: "Default"
			configuration: {}
			input: [
				{log: {"message": "First", "_partial":            true, "custom_string_field":  "value1", "custom_int_field": 1}},
				{log: {"message": "Second", "_partial":           true, "custom_string_field":  "value2", "custom_int_field": 2}},
				{log: {"message": "Third", "custom_string_field": "value3", "custom_int_field": 3}},
			]
			output: log: {"message": "FirstSecondThird", "custom_string_field": "value1", "custom_int_field": 1}
			notes: """
				Notice that `custom_string_field` and `custom_int_field` were not overridden.
				This is because they were not listed in the `fields` option.
				"""
		},
		{
			title: "With Merge Fields"
			configuration: {
				fields: ["message", "custom_string_field", "custom_int_field"]
			}
			input: [
				{log: {"message": "First", "_partial":            true, "custom_string_field":  "value1", "custom_int_field": 1}},
				{log: {"message": "Second", "_partial":           true, "custom_string_field":  "value2", "custom_int_field": 2}},
				{log: {"message": "Third", "custom_string_field": "value3", "custom_int_field": 3}},
			]
			output: log: {"message": "FirstSecondThird", "custom_string_field": "value1value2value3", "custom_int_field": 3}
			notes: """
				Notice that `custom_string_field` is concatenated and `custom_int_field`
				overridden. This is because it was specified in the `fields` option.
				"""
		},
	]
}
