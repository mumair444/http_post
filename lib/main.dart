import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void postData() async {
    try {
      String username = 'Inzi';
      String password = '123';
      final url =
          'https://klm.easycloud.in/klm/ws/in.easycloud.commons.QueryService?l=$username&p=$password';

      var response = await post(Uri.parse(url),
          body: jsonEncode({
            "data": {
              "query":
                  "select sum(t.closed) as closed,sum(t.open) as open,sum(t.overdue) as overdue from (select ad_org_id,count(*) as closed, 0 as open, 0 as overdue from TMS_Taskmanagement where status='Close' and EM_Klm_Tickettype='Standard' and priority in ('Low') and date(created)>=date('2022-03-01') and date(created)<=date('2022-03-17') and C_Doctype_ID='B2AA580A19EC4F57A13A862137E05159' group by ad_org_id union select tms.ad_org_id,0 as closed, count(*) as open, (select count(*) from TMS_Taskmanagement where status='Open' and date(duedate)<date(now()) and ad_org_id=tms.ad_org_id and EM_Klm_Tickettype='Standard' and priority in ('Low') and date(created)>=date('2022-03-01') and date(created)<=date('2022-03-17') and C_Doctype_ID='B2AA580A19EC4F57A13A862137E05159') as overdue from TMS_Taskmanagement tms where status='Open' and EM_Klm_Tickettype='Standard' and priority in ('Low') and date(tms.created)>=date('2022-03-01') and date(tms.created)<=date('2022-03-17') and C_Doctype_ID='B2AA580A19EC4F57A13A862137E05159' group by ad_org_id) t left join ad_org org on org.ad_org_id=t.ad_org_id",
              "placeholders": {
                "tktpriority": "Low",
                "categoryId": "",
                "fromdate": "2022-03-1",
                "todate": "2022-03-17"
              }
            }
          }));
      print(response.body);
    } catch (err, stack) {
      print(err);
      print(stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: postData,
            child: const Text('Post Data'),
          ),
        ),
      ),
    );
  }
}
