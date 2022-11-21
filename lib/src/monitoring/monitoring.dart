import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:networking/src/logger/log_model.dart';
import 'package:networking/src/logger/logger.dart';
import 'package:networking/src/logger/logger_result_type.dart';
import 'package:networking/src/monitoring/monitoring_detail.dart';

class ANMonitoring extends StatelessWidget {
  const ANMonitoring({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network Monitor"),
        actions: [
          TextButton(
            onPressed: () {
              Logger.shared.clear();
            },
            child: const Text(
              "Clear",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: _getContent(),
        ),
      ),
    );
  }

  Widget _getContent() {
    return StreamBuilder<List<LogModel>>(
      stream: Logger.shared.logStream(),
      builder: (context, snapshot) {
        List<LogModel> logs = snapshot.data ?? [];

        if (logs.isEmpty) {
          logs = Logger.shared.logs();
        }

        if (logs.isEmpty) {
          return const Center(
            child: Text("No Network Activity Found"),
          );
        }

        logs.sort((a, b) {
          return b.request.time.compareTo(a.request.time);
        });

        return ListView.builder(
          itemBuilder: (context, index) {
            LogModel log = logs[index];

            String status;
            bool isLast = index == (snapshot.data?.length ?? 0) - 1;

            if (log.result == LoggerResultType.success) {
              status = "✅ ";
            } else {
              status = "❌ ";
            }

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) {
                      return MonitoringDetail(log: log);
                    },
                  ),
                );
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$status ${log.method}: ${log.url}"),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      height: 0.5,
                      color: Colors.grey,
                    )
                  ],
                ),
                margin: EdgeInsets.only(bottom: !isLast ? 8.0 : 0.0),
              ),
            );
          },
          itemCount: logs.length,
        );
      },
    );
  }
}
