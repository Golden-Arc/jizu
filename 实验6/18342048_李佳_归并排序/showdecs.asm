;showdecs.asm
data segment
     nums1 db 100,34,78,9,160,200,90,65
data ends

code segment
      assume cs:code
      
start:     
     mov ax,data
     mov ds,ax
     mov es,ax

     mov bx,offset nums1
     mov cx,8
     call showdecs

     mov ah,4ch              ; ���ܣ�����DOSϵͳ
     int 21h                 ;       DOS���ܵ���

; ��һ��ʮ����������ת��Ϊʮ����������ʾ����
; ������ds:bx --����ַ cx -- ���ݸ���
showdecs proc near
	
  trans:mov bp,cx
		mov ah,0
		mov al,[bx]
		
		mov cl,100
		div cl
		add al,30H
		mov dl,al
		mov dh,ah
		mov ah,02h              ; ���ܣ���ʾ���
		int 21h
		
		mov ah,0
		mov al,dh
		mov cl,10
		div cl
		add al,30H
		mov dl,al
		mov dh,ah
		mov ah,02h              ; ���ܣ���ʾ���
		int 21h
		
		
		add dh,30H
		mov dl,dh
		mov al,ah
		mov ah,02h              ; ���ܣ���ʾ���
		int 21h
		
		
		mov cx,bp
		inc bx
		; �������	
		mov dl,0ah
		mov ah,02h              ; ���ܣ���ʾ���
		int 21h	
	
	loop trans
	
      ret
showdecs endp

code  ends
      end start