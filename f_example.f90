program passive_one_sided

use mpi

implicit none

integer :: rank, comm_size, ierr, tag, status(MPI_STATUS_SIZE)

integer, parameter :: data_count = 10
real :: mydata(data_count) ! going in the window
real :: x
integer :: datasize = MPI_REAL4
integer :: bytesize ! size in bytes of each element in the window
integer :: windex  ! window
integer(KIND=MPI_ADDRESS_KIND) :: window_size
integer(KIND=MPI_ADDRESS_KIND) :: target_disp = 2

call mpi_init(ierr)
call mpi_comm_size(mpi_comm_world, comm_size, ierr)
call mpi_comm_rank(mpi_comm_world, rank, ierr)


if (comm_size /= 2) then
  print*, 'Only run this with two processors'
  call mpi_abort(mpi_comm_world, -1, ierr)
endif

print*, 'Hello from rank ', rank, ' of ', comm_size

x = 42
mydata(:) = rank

call mpi_type_size(datasize, bytesize, ierr)

window_size = data_count*bytesize

call mpi_win_create(mydata, window_size, bytesize, MPI_INFO_NULL, MPI_COMM_WORLD, windex, ierr)

if (rank == 0) then
   call mpi_win_lock(MPI_LOCK_SHARED, 1, 0, windex, ierr)
   call mpi_get(x, 1, datasize, 1, target_disp, 1, datasize, windex, ierr)
   call mpi_win_unlock(1, windex, ierr)
endif

call mpi_win_free(windex, ierr)

if (rank == 0) print*, x

call mpi_finalize(ierr)

end program passive_one_sided
