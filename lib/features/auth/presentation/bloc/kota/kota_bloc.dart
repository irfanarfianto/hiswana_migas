import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/auth/domain/entities/kota_entities.dart';
import 'package:hiswana_migas/features/auth/domain/usecase/get_kota.dart';

part 'kota_event.dart';
part 'kota_state.dart';

class KotaBloc extends Bloc<KotaEvent, KotaState> {
  GetKotaUsecase getKota;
  KotaBloc({
    required this.getKota,
  }) : super(KotaInitial()) {
    on<GetKota>((event, emit) async {
      emit(KotaLoading());
      try {
        final result = await getKota.execute(event.provinsiCode);
        emit(result.fold(
          (failure) => KotaError(message: _mapFailureToMessage(failure)),
          (kota) => KotaLoaded(kota: kota),
        ));
      } catch (e) {
        emit(KotaError(message: e.toString()));
      }
    });
  }
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Error: ${failure.message}';
    } else if (failure is NetworkFailure) {
      return 'Network Error: ${failure.message}';
    } else {
      return 'Unexpected Error: ${failure.message}';
    }
  }
}
