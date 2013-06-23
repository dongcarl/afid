function readings=getreadings(a, b1, b0)
readings=zeros(1, 10);

a.digitalWrite(b1, 0);
a.digitalWrite(b0, 0);
readings(1)=a.analogRead(0);
readings(2)=a.analogRead(2);
readings(3)=a.analogRead(3);
readings(4)=a.analogRead(4);

a.digitalWrite(b0, 1);
readings(5)=a.analogRead(0);
readings(6)=a.analogRead(2);
readings(7)=a.analogRead(3);
readings(8)=a.analogRead(4);
  
a.digitalWrite(b1, 1); 
a.digitalWrite(b0, 0);
readings(9)=a.analogRead(0);
readings(10)=a.analogRead(2);

end