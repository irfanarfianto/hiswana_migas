import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hiswana_migas/core/failure.dart';
import 'package:hiswana_migas/features/auth/domain/entities/provinsi_entities.dart';
import 'package:hiswana_migas/features/auth/domain/usecase/get_provinsi.dart';

part 'provinsi_event.dart';
part 'provinsi_state.dart';

class ProvinsiBloc extends Bloc<ProvinsiEvent, ProvinsiState> {
  GetProvinsiUsecase getProvinsi;

  ProvinsiBloc({
    required this.getProvinsi,
  }) : super(ProvinsiInitial()) {
    on<GetProvinsi>((event, emit) async {
      emit(ProvinsiLoading());
      try {
        final result = await getProvinsi.execute();
        emit(result.fold(
          (failure) => ProvinsiError(message: _mapFailureToMessage(failure)),
          (provinsi) => ProvinsiLoaded(provinsi: provinsi),
        ));
      } catch (e) {
        emit(ProvinsiError(message: e.toString()));
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
