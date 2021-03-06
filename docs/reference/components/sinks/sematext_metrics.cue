package metadata

components: sinks: sematext_metrics: {
	title:             "Sematext Metrics"
	short_description: "Batches metric events to [Sematext][urls.sematext] to the [Sematext monitoring][urls.sematext_monitoring] service."
	long_description:  "[Sematext][urls.sematext] is a hosted monitoring platform for metrics based on InfluxDB. Providing powerful monitoring and management solutions to monitor and observe your apps in real-time."

	classes: {
		commonly_used: false
		delivery:      "at_least_once"
		development:   "beta"
		function:      "transmit"
		service_providers: ["Sematext"]
		egress_method: "batch"
	}

	features: {
		batch: {
			enabled:      true
			common:       false
			max_bytes:    30000000
			max_events:   null
			timeout_secs: 1
		}
		buffer: enabled:      true
		compression: enabled: false
		encoding: codec: enabled: false
		healthcheck: enabled: true
		request: enabled:     false
		tls: enabled:         false
	}

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
		warnings: [
			#"""
				[Sematext monitoring][urls.sematext_monitoring] only accepts metrics which contain a single value.
				Therefore, only `counter` and `gauge` metrics are supported. If you'd like to ingest other
				metric types please consider using the [`metric_to_log` transform][docs.transforms.metric_to_log]
				with the `sematext_logs` sink.
				"""#,
		]
		notices: []
	}

	configuration: sinks._sematext.configuration

	input: {
		logs: false
		metrics: {
			counter:      true
			distribution: false
			gauge:        true
			histogram:    false
			set:          false
			summary:      false
		}
	}

	how_it_works: {
		metric_types: {
			title: "Metric Namespaces"
			body: #"""
				All metrics are sent with a namespace. If no namespace is included with the metric, the metric name becomes
				the namespace and the metric is named `value`.
				"""#
		}
	}
}
