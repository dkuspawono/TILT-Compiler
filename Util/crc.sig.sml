signature CRC =
  sig
    eqtype crc
    val output_crc : BinIO.outstream * crc -> unit
    val input_crc : BinIO.instream -> crc
      
    val crc_of_string : string -> crc
    val crc_of_file : string -> crc
  end