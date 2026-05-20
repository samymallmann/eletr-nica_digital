module seven_seg_decoder(
    input [3:0] value,
    output reg [6:0] segments
);

always @(*) begin
    case (value)
        0: segments = 7'b1000000;
        1: segments = 7'b1111001;
        2: segments = 7'b0100100;
        3: segments = 7'b0110000;
        4: segments = 7'b0011001;
        5: segments = 7'b0010010;
        6: segments = 7'b0000010;
        7: segments = 7'b1111000;
        8: segments = 7'b0000000;
        9: segments = 7'b0010000;
		  
		  4'd14: segments = 7'b0000110; // "E" de Estourou (ou Error)
        4'd15: segments = 7'b1111111; // apagado

        default: segments = 7'b1111111;
    endcase
end

endmodule