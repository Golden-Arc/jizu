;msort.asm
data segment
     nums1 db 100,34,78,9,160,200,90,65
     nums2 db 212,152,8,49,83,35,79,51
     buffer db 8 dup(?)               ; ���������������н��кϲ��Ļ�����
     bufptr dw 0                      ; buffer���Ѻϲ����ݵĸ���
data ends

code segment
      assume cs:code
      
start:     
     mov ax,data
     mov ds,ax
     mov es,ax

     ;��nums1�е�����������ʾ
     mov bx,offset nums1
     mov cx,8
     call mergesort
     call showdecs
     
     ;��ʾ���кͻس�
     mov dl,0ah
     mov ah, 02h
     int 21h
     mov dl,0dh
     mov ah, 02h
     int 21h
     
     ;��nums2�е�����������ʾ
     mov bx,offset nums2
     mov cx,8
     call mergesort
     call showdecs

     mov ah,4ch              ; ���ܣ�����DOSϵͳ
     int 21h                 ;       DOS���ܵ���

; ��һ�����ݽ��й鲢���򣨲��õݹ鷽��ʵ�֣�
; bx--����ַ addr cx--���ݸ���
mergesort proc near	
	push bx
	push cx
	
	cmp cx,1
	jz merge
		
	divide:;cx>1,���ݸ������룬�ݹ��
	
	mov ax,cx
	mov cl,2
    div cl
	mov cl,al
	mov ch,0	;cx/=2
	
    call mergesort
	add bx,cx
	call mergesort
	 
	;��
	merge:
	pop cx
	pop bx
	call mergepart
	ret
mergesort endp


; �������ѷֱ���������ݽ��кϲ��������������ݵĸ�����ͬ
;    �м������Դ�ŵ�buffer�У������Ҫ�ŵ�ԭ����
; ������bx--����ַ��������������ţ�,cx--�����ݵĸ���
mergepart proc near
	cmp cx,1
	jz jumpover
	
	push cx
	mov ax,cx
	mov cl,2
    div cl
	mov cl,al
	mov ch,0	;cx/=2
	
	mov bp,bx
	add bp,cx
	
	mov si,0
	mov di,0	
	
	compare:
	mov al,ds:[bp+di]
	cmp [bx+si],al
	inc di
	ja save
	
	mov al,[bx+si]
	dec di
	inc si
	
	save: 
	call saveToBuffer
	
	cmp di,cx
	je copysi
	cmp si,cx
	je copydi
	
	jmp compare
	
	copydi:
	mov al,ds:[bp+di]
	call saveToBuffer
	inc di
	cmp di,cx
	jne copydi
	jmp ending
	copysi:
	mov al,[bx+si]
	call saveToBuffer
	inc si
	cmp si,cx
	jne copysi
	ending:
	pop cx
	call copyFromBufferToNums
	jumpover:
    ret
mergepart endp

; ��buffer�е����ݿ�����bx��ʼ�Ĵ洢����
; ������bx--����ַ,cx--���ݸ���
copyFromBufferToNums proc
	push cx
	push bx
	lea bp,buffer
	
	btobx:
	mov al,ds:[bp]
	mov [bx],al
	inc bx
	inc bp
	loop btobx
	
	lea si,bufptr
	mov WORD PTR[si],0
	pop bx
	pop cx
    ret
copyFromBufferToNums endp

; ��al�����ݱ��浽buffer��
saveToBuffer proc
	push bx
	push si
	lea bx,buffer
	lea si,bufptr
	add bx,[si]
	mov [bx],al
	inc WORD PTR[si]
	pop si
	pop bx
    ret
saveToBuffer endp

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