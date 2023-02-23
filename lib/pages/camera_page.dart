import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mqtt/utils/colors.dart';

class CameraPage extends ConsumerWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: CameraPageBody()
    );
  }
}

final imageDeviceProvider = FutureProvider<dynamic>((ref) async {
  final ImagePicker _picker = ImagePicker();

  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  return image;
});

class CameraPageBody extends ConsumerWidget {
  const CameraPageBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.black45),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 15,
              child: InkWell(
                onTap: () => context.go('/'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    shape: BoxShape.circle
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white, size: 20,),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: const BorderRadius.all(Radius.circular(6))
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.video_camera_front_rounded, 
                              color: Colors.white, 
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Camera 2", style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14
                              ),),
                              Text("11:01:21", style: TextStyle(
                                color: Colors.white.withOpacity(.7),
                                fontSize: 12
                              ),)
                            ],
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                              ),
                            ),
                            const SizedBox(width: 5,),
                            const Text("Live", style: 
                              TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.black.withOpacity(0.8)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => showModalImage(context),
                          child: Icon(Icons.image, color: Colors.grey[300], size: 25,)
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.redAccent),
                            shape: BoxShape.circle
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.camera, color: Colors.redAccent, size: 35,),
                        ),
                        Icon(Icons.replay_outlined, color: Colors.grey[300], size: 25,)
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showModalImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8)
        )
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Thư viện ảnh", style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600
                ),),
                SizedBox(height: 15,),
                ListImageInDevice()
              ],
            ),
          )
        );
      });
  }
}

class ListImageInDevice extends ConsumerWidget {
  const ListImageInDevice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.read(imageDeviceProvider);
    return images.when(
      data: (data) {
        print(data);
        return GridView.builder(
          shrinkWrap: true,
          itemCount: 30,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1
          ),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(color: Colors.red),
            );
          },
        );
      },
      error: (_,__) => const Text('Error 😭'),
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      )
    );
  }
}