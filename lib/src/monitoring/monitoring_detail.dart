import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:networking/src/logger/log_model.dart';
import 'package:pretty_json/pretty_json.dart';

class MonitoringDetail extends StatefulWidget {
  final LogModel log;

  const MonitoringDetail({Key? key, required this.log}) : super(key: key);

  @override
  _MonitoringDetailState createState() => _MonitoringDetailState();
}

class _MonitoringDetailState extends State<MonitoringDetail> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.log.url),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Info",
              ),
              Tab(
                text: "Request",
              ),
              Tab(
                text: "Response",
              )
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(16.0),
              child: TabBarView(
                children: [
                  _getInfoPage(),
                  _getDataPage(
                    header: widget.log.request.header,
                    data: widget.log.request.getObject(),
                  ),
                  _getDataPage(
                    header: widget.log.response?.header,
                    data: widget.log.response?.getObject(),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget _getInfoPage() {
    DateTime requestTime = widget.log.request.time;
    DateTime? responseTime = widget.log.response?.time;
    String requestTimeString =
        "${requestTime.hour}:${requestTime.minute}:${requestTime.second}";
    String responseTimeString = "-";
    String duration = "-";

    if (responseTime != null) {
      responseTimeString =
          "${responseTime.hour}:${responseTime.minute}:${responseTime.second}";

      Duration diff = responseTime.difference(requestTime);
      duration = "${diff.inMilliseconds}ms";
    }

    return ListView(
      children: [
        ListTile(
          title: const Text("Method"),
          subtitle: Text(widget.log.method),
        ),
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Url"),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.log.url));
                  _showSnackBar("Url copied to clipboard");
                },
                child: const Text(
                  "copy",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          subtitle: Text(widget.log.url),
        ),
        ListTile(
          title: const Text("Status Code"),
          subtitle: Text(widget.log.code.toString()),
        ),
        ListTile(
          title: const Text("Request Time"),
          subtitle: Text(requestTimeString),
        ),
        ListTile(
          title: const Text("Response Time"),
          subtitle: Text(responseTimeString),
        ),
        ListTile(
          title: const Text("Duration"),
          subtitle: Text(duration),
        ),
      ],
    );
  }

  Widget _getDataPage({
    dynamic header,
    dynamic data,
  }) {
    return ListView(
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("-- Header"),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: prettyJson(header)));
                  _showSnackBar("Header copied to clipboard");
                },
                child: const Text(
                  "copy",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          subtitle: Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              prettyJson(header),
            ),
          ),
        ),
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("-- Data"),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: prettyJson(data)));
                  _showSnackBar("Body copied to clipboard");
                },
                child: const Text(
                  "copy",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          subtitle: Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              prettyJson(data),
            ),
          ),
        )
      ],
    );
  }

  void _showSnackBar(String title) {
    SnackBar snackBar = SnackBar(
      content: Text(title),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
