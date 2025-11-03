// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fan_poll/app/utills/image_path.dart';
// import '../controllers/editprofile_controller.dart';
// import 'package:fan_poll/app/utills/textsyles.dart';
// import 'package:fan_poll/app/widget/button.dart';
// import 'package:fan_poll/app/utills/color.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';

// class EditprofileView extends GetView<EditprofileController> {
//   const EditprofileView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final EditprofileController editprofileController =
//         Get.put(EditprofileController());
//     return Scaffold(
//         backgroundColor: AppColor.WhiteColor,
//         appBar: AppBar(
//           backgroundColor: AppColor.WhiteColor,
//           title: Text(
//             'Edit Profile',
//             style: CustomText.semiBold18(const Color(0xff22212F)),
//           ),
//           titleSpacing: 0,
//           leading: IconButton(
//             onPressed: () => Get.back(),
//             icon: SvgPicture.asset(AssetPath.BackArrow, height: 24, width: 24),
//           ),
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   AssetPath.ProfileImg,
//                   height: 130.h,
//                   width: 130.h,
//                   fit: BoxFit.contain,
//                 ),
//                 SizedBox(
//                   height: 60,
//                 ),
//                 _buildTextFormField(
//                   controller: editprofileController.userNameController,
//                   hintText: "Enter Your Name",
//                 ),
//                 const SizedBox(height: 8),
//                 _buildTextFormField(
//                   controller: editprofileController.emailController,
//                   hintText: "Enter Email",
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 CustomButton(
//                   text: "Edit",
//                   onTap: () async {
//                     controller.onEditProfile();
//                   },
//                 ),
//                 SizedBox(
//                   height: 50,
//                 )
//               ],
//             ),
//           ),
//         ));
//   }

//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String hintText,
//     Widget? suffixIcon,
//     String? counterText,
//   }) {
//     return TextFormField(
//         controller: controller,
//         // textInputAction: TextInputAction.done,
//         style: CustomText.regular12(const Color(0xff22212F)),
//         cursorColor: AppColor.PrimaryColor,
//         maxLines: 1,
//         minLines: 1,
//         textInputAction: TextInputAction.newline,
//         // validator: (value) =>
//         //     value == null || value.trim().isEmpty ? 'Required' : null,
//         decoration: InputDecoration(
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
//             counterText: counterText,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: BorderSide(color: Color(0x8022212F), width: 0.5),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: BorderSide(color: Color(0x8022212F), width: 0.5),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: BorderSide(color: Color(0x8022212F), width: 0.5),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: BorderSide(color: Color(0x8022212F), width: 0.5),
//             ),
//             filled: true,
//             fillColor: AppColor.WhiteColor,
//             hintText: hintText,
//             hintStyle: const TextStyle(
//               fontSize: 14,
//               fontFamily: "Poppins",
//               fontWeight: FontWeight.w300,
//               color: Color(0x8022212F),
//             ),
//             prefixIcon: suffixIcon
//             // prefix: suffixIcon),
//             ));
//   }
// }

// ignore_for_file: unused_import, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/textsyles.dart';
import 'package:fan_poll/app/widget/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/editprofile_controller.dart';

class EditprofileView extends GetView<EditprofileController> {
  const EditprofileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditprofileController());

    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.WhiteColor,
        title: Text("Edit Profile", style: CustomText.semiBold18(const Color(0xff22212F))),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset(AssetPath.BackArrow, height: 24, width: 24),
        ),
      ),
      body: Center(
        child: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Obx(() {
                    final isNetworkImage = controller.selectedImage.value == null && (controller.user.value?.profilePicture.isNotEmpty ?? false);
                    final networkImageUrl = controller.user.value?.profilePicture ?? '';

                    return GestureDetector(
                      onTap: controller.pickImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey[200],
                            child: ClipOval(
                              child: controller.selectedImage.value != null
                                  ? kIsWeb
                                      ? Image.memory(
                                          controller.selectedByteImage.value!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          controller.selectedImage.value!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover, // You can also try BoxFit.contain
                                        )
                                  : isNetworkImage
                                      ? Image.network(
                                          networkImageUrl,
                                          width: 130,
                                          height: 130,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return SizedBox(
                                              width: 130,
                                              height: 130,
                                              child: Center(child: CircularProgressIndicator()),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              AssetPath.ProfileImg,
                                              width: 130,
                                              height: 130,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          AssetPath.ProfileImg,
                                          width: 130,
                                          height: 130,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // GestureDetector(
                  //   onTap: controller.pickImage,
                  //   child: Obx(() => CircleAvatar(
                  //         radius: 65,
                  //         backgroundImage: controller.selectedImage.value != null
                  //             ? FileImage(controller.selectedImage.value!)
                  //             : (controller.user.value?.profilePicture
                  //                         .isNotEmpty ??
                  //                     false)
                  //                 ? NetworkImage(
                  //                     controller.user.value!.profilePicture)
                  //                 : AssetImage(AssetPath.ProfileImg),
                  //       )),
                  // ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    controller: controller.userNameController,
                    hintText: "Enter Your Name",
                    validator: (value) => value!.trim().isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.bioController,
                    hintText: "Enter Bio",
                    maxLines: 5,
                    validator: (value) => value!.trim().isEmpty ? 'Bio is required' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: "Update",
                    isLoading: controller.isLoading.value,
                    onTap: controller.validateAndSubmit,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: CustomText.regular12(const Color(0xff22212F)),
      cursorColor: AppColor.PrimaryColor,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0x8022212F), width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0x8022212F), width: 0.5),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w300,
          color: Color(0x8022212F),
        ),
        filled: true,
        fillColor: AppColor.WhiteColor,
      ),
    );
  }
}
