import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/delete/delete_cubit.dart';
import 'package:provider/provider.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final int postId;

  const DeleteConfirmationDialog({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Konfirmasi Penghapusan'),
      content: const Text('Apakah Anda yakin ingin menghapus post ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            context.read<DeletePostCubit>().deletePost(postId);
            context.pop(true);
          },
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
