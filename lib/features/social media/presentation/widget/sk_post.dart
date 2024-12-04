import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostSkeletonWidget extends StatelessWidget {
  const PostSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Skeletonizer(
              enabled: true,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                      ),
                      title: Skeletonizer(
                        enabled: true,
                        child: Container(
                          height: 12,
                          width: 100,
                          color: Colors.grey[300],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Skeletonizer(
                            enabled: true,
                            child: Container(
                              height: 10,
                              width: 150,
                              color: Colors.grey[300],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Skeletonizer(
                            enabled: true,
                            child: Container(
                              height: 10,
                              width: 100,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      trailing: Skeletonizer(
                        enabled: true,
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Skeletonizer(
                        enabled: true,
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Skeletonizer(
                            enabled: true,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Skeletonizer(
                            enabled: true,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Skeletonizer(
                        enabled: true,
                        child: Container(
                          height: 12,
                          width: 80,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
