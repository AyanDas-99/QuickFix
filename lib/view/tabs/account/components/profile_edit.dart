import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/models/shipping_address.dart';
import 'package:quickfix/state/user/models/user.dart';
import 'package:quickfix/state/user/providers/user_by_id.dart';
import 'package:quickfix/state/user/providers/user_provider.dart';
import 'package:quickfix/state/user/repositories/update_user.dart';
import 'package:quickfix/view/components/custom_app_bar.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/theme/QFTheme.dart';

class ProfileEdit extends ConsumerStatefulWidget {
  const ProfileEdit({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileEditState();
}

class _ProfileEditState extends ConsumerState<ProfileEdit> {
  User? myuser;

// Name
  final nameController = TextEditingController();

  // Address
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final houseNoController = TextEditingController();
  final landmarkController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // Update all text controller to the initial user values
  initializeControllers() async {
    final uid = ref.read(userProvider)!.uid;
    myuser = await ref.read(UserByIdProvider(uid).future);
    nameController.text = myuser!.displayName ?? '';
    streetController.text = myuser!.shippingAddress?.street ?? '';
    cityController.text = myuser!.shippingAddress?.city ?? '';
    stateController.text = myuser!.shippingAddress?.state ?? '';
    pincodeController.text = myuser!.shippingAddress?.pincode ?? '';
    houseNoController.text = myuser!.shippingAddress?.houseNo ?? '';
    landmarkController.text = myuser!.shippingAddress?.landmark ?? '';
    setState(() {});
  }

  updateName() async {
    await ref
        .read(updateUserRepositoryProvider.notifier)
        .updateName(nameController.text);
    initializeControllers();
  }

  updateAddress() async {
    if (!formKey.currentState!.validate()) return;
    await ref.read(updateUserRepositoryProvider.notifier).updateAddress(
        ShippingAddress(
            street: streetController.text,
            city: cityController.text,
            state: stateController.text,
            pincode: pincodeController.text,
            houseNo: houseNoController.text,
            landmark: landmarkController.text));
    initializeControllers();
  }

  @override
  Widget build(BuildContext context) {
    final updateUserLoading = ref.watch(updateUserRepositoryProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(false, context: context, canGoBack: true),
          body: (myuser == null)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  children: [
                    // Name update
                    const Text(
                      'Name',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      onChanged: (value) => setState(() {}),
                      controller: nameController,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        hintText: 'Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MainButton(
                        onPressed: (nameController.text == myuser!.displayName)
                            ? () {}
                            : updateName,
                        backgroundColor:
                            (nameController.text == myuser!.displayName)
                                ? Colors.greenAccent.shade200
                                : QFTheme.mainGreen,
                        child: const Text(
                          'Update Name',
                          style: TextStyle(color: Colors.white),
                        )),

                    const SizedBox(height: 30),
                    // Address Update
                    const Text(
                      'Address',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'House number cannot be empty';
                              }
                              return null;
                            },
                            controller: houseNoController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              hintText: 'House number/name',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Street cannot be empty';
                              }
                              return null;
                            },
                            controller: streetController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              hintText: 'Street',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'City cannot be empty';
                              }
                              return null;
                            },
                            controller: cityController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              hintText: 'City',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Landmark cannot be empty';
                              }
                              return null;
                            },
                            controller: landmarkController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              hintText: 'Landmark, eg- Near Apollo Hospital',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'State cannot be empty';
                              }
                              return null;
                            },
                            controller: stateController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              hintText: 'State',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pincode cannot be empty';
                              }
                              return null;
                            },
                            controller: pincodeController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              hintText: 'Pincode',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          MainButton(
                              onPressed: updateAddress,
                              backgroundColor: QFTheme.mainGreen,
                              child: const Text(
                                'Update Address',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        if (updateUserLoading)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
