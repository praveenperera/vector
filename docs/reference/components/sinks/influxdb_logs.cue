package metadata

components: sinks: influxdb_logs: {
	title:             "InfluxDB Logs"
	short_description: "Batches log events to [InfluxDB][urls.influxdb] using [v1][urls.influxdb_http_api_v1] or [v2][urls.influxdb_http_api_v2] HTTP API."
	long_description:  "[InfluxDB][urls.influxdb] is an open-source time series database developed by InfluxData. It is written in Go and optimized for fast, high-availability storage and retrieval of time series data in fields such as operations monitoring, application metrics, Internet of Things sensor data, and real-time analytics."

	classes: {
		commonly_used: false
		delivery:      "at_least_once"
		development:   "beta"
		egress_method: "batch"
		function:      "transmit"
		service_providers: ["InfluxData"]
	}

	features: {
		batch: {
			enabled:      true
			common:       false
			max_bytes:    1049000
			max_events:   null
			timeout_secs: 1
		}
		buffer: enabled:      true
		compression: enabled: false
		encoding: codec: enabled: false
		healthcheck: enabled: true
		request: {
			enabled:                    true
			in_flight_limit:            5
			rate_limit_duration_secs:   1
			rate_limit_num:             5
			retry_initial_backoff_secs: 1
			retry_max_duration_secs:    10
			timeout_secs:               60
		}
		tls: enabled: false
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
		warnings: []
		notices: []
	}

	configuration: sinks._influxdb.configuration

	input: {
		logs:    true
		metrics: false
	}

	how_it_works: {
		mapping: {
			title: "Mapping Log Fields"
			body: #"""
				InfluxDB uses [line protocol][urls.influxdb_line_protocol] to write data points. It is a text-based format that provides the measurement, tag set, field set, and timestamp of a data point.

				A `Log Event` event contains an arbitrary set of fields (key/value pairs) that describe the event.

				The following matrix outlines how Log Event fields are mapped into InfluxDB Line Protocol:

				| Field         | Line Protocol     |                                                                                                                                                 |
				|---------------|-------------------|
				| host          | tag               |
				| message       | field             |
				| source_type   | tag               |
				| timestamp     | timestamp         |
				| [custom-key]  | field             |

				The default behavior can be overridden by a `tags` configuration.
				"""#
		}
	}
}
