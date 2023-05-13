import 'package:flutter/material.dart';
import 'package:homeze_screens/responsive/mobile_screen.dart';
import 'package:homeze_screens/screens/post_job.dart';
import 'package:homeze_screens/utils/constants.dart';
import 'package:homeze_screens/widgets/small_widgets.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: skyclr,
          title: const Text(
            'Select a service',
            style: TextStyle(
                color: blueclr, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostJob()));
                },
                icon: const Icon(
                  Icons.calendar_month,
                  color: blueclr,
                )),
          ],
          elevation: 1,
        ),
        body: SafeArea(
            child: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: const Center(
                  child: Text(
                    'What service do\nyou need?',
                    style: TextStyle(
                        color: blueclr,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Services(
                                serviceName: 'Cleaning',
                                serviceImage: cleaning),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Plumber', serviceImage: plumber),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Carpenter',
                                serviceImage: carpenter),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Services(
                                serviceName: 'AC Service', serviceImage: ac),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Appliances',
                                serviceImage: appliance),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Beautician',
                                serviceImage: beautician),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Services(
                                serviceName: 'Car Wash', serviceImage: carwash),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Electrician',
                                serviceImage: electrician),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Event Planner',
                                serviceImage: event),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Services(
                                serviceName: 'Trainer', serviceImage: fitness),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Gardener',
                                serviceImage: gardener),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Geyser', serviceImage: geyser),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Services(serviceName: 'Labor', serviceImage: labor),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Mechanic',
                                serviceImage: mechanic),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Moving', serviceImage: moving),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Services(
                                serviceName: 'Painter', serviceImage: painter),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Photographer',
                                serviceImage: photographer),
                            const SizedBox(
                              width: 10,
                            ),
                            Services(
                                serviceName: 'Tailor', serviceImage: tailor),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Services(
                                serviceName: 'Other', serviceImage: others),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
