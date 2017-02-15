%MAIN PART OF CODE
function main(execution_number, methode_pi)
  K_gen = 123456789;
  n = 40;
  a = 2;
  c = 4;
  m = 20;
  Xo = 1;
  file_R250 = "aleatoire250.txt";
  nb_stoll = 1000;
  nb_calc_pi = 1000;
  switch execution_number
    case 1 
      k_algo(K_gen)
    case 2
      x = R250_GEN(n, a, c, m, Xo)
      rdm_period(x)
      IBM_GEN();
    case 3
      X = R250_generator(file_R250, nb_stoll);
      figure ('name','R250 STOLL KIRCKPATRICK Generator');
      subplot(2, 1, 1)
      plot(X(1:end-1) , X(2:end))
      title('Xi-1 , Xi')
      subplot(2, 1, 2)
      plot3(X(1:end-2) , X(2:end-1) , X(3:end))
      title('Xi-2, Xi-1 , Xi')
    case 4
      f_approx_pi(methode_pi, nb_calc_pi)
  endswitch
endfunction

%STOLL KIRCK ALGO
function X = R250_generator(filename, nbr_val)
  X = importdata(filename);
  for i=size(X) : nbr_val
    X(i+1) = bitxor( X(i-249) , X(i-102) );
  endfor
  X;
endfunction

%STOLL KIRCK GENERATOR
function X = R250_GEN(n, a, c, m, Xo)
  X = zeros(n,1);
  X(1,1) = Xo;
  for k = 1 : n
    X(k+1,1) = mod(a*X(k,1) + c , m);
  endfor
  return
endfunction

%IBM ALGO GENERATOR
function IBM_GEN()
  X = R250_GEN (12000, 65539, 0, 2^31, 123456789);
  figure ('name','Random IBM Generator');
  figure(1);
  subplot(2, 1, 1)
  plot(X(1:end-1) , X(2:end))
  title('Xi-1 , Xi')
  xlabel('x');
  ylabel('y');
  subplot(2, 1, 2)
  plot(X(1:end-2) , X(2:end-1) , X(3:end))
  title('Xi-2, Xi-1 , Xi')
  xlabel('x');
  ylabel('y');
endfunction

%FUNCTION RANDOM PERIODE
function p = rdm_period(x)
  len = size(x, 1);
  period = 1;
  solved = false;
  while not(solved)
    values_corect = false;
    next_found = false;
    for i = (period+1):len 
      if(x(1) == x(i))
        period = i - 1;
        next_found = true;
        break;
      endif
    endfor
    if(next_found)
      val = floor(len / period); 
      if(val > 1)
        values_corect = chck_vals(x, period, val);
        if(values_corect == true)
          solved = true;
        else
          period = period + 1;
        endif
      else
        solved = true;
      endif
    else
      solved = true;
    endif
  endwhile
  if(values_corect)
    p = period;
  else
    p = 0;
  endif
  return
endfunction

function b = chck_vals(x, period, val)
  b = true;
  for i = 1:period
    for j = 1:(val - 1)
      idx = i + (j * period);
      if(x(i) ~= x(idx))
        b = false;
        break;
      endif
    endfor
    if(b == false)
      break;
    endif
  endfor
  return
endfunction

%FUNCTION TO GET RANDOM cordINATES
function cord = rdm_cord(nbr_val)
  cord = rand([nbr_val,2]);
  return
endfunction

%ALGO K
function X = k_algo(X)
  %// choix nombre d’iterations
  Y = floor(X/10^5);
  for i=1:Y-1;
    %// choix d’operation aleatoire
    Z = mod(floor(X/(10^4)), 10);
    if Z==1 || Z==9
      X = mod(X^2/10^3, 10^6);
    elseif (Z==2 || Z==5)
      X = mod(1001001 * X, 10^6);
    elseif Z==3
      %// inverser les chiffres
      X = 10^3 * (mod(X, 10^3)) + floor(X/(10^3));
    elseif (Z==4 || Z==8)
      if X<10^4
        X=X+20469;
      else
        X=10^6-X;
      endif
    elseif (Z==6 || Z==7)
      if X<5*10^3
        X=X+5*10^3;
      endif
    endif
  endfor
  return
endfunction

%GET ARRAY FOR K ALGO
function X = get_karray(loop)
  loop = loop * 2;
  for i=1 : loop
    r = 0 + (10^7-1) * rand();
    X(i,1) = k_algo(r);
  endfor
  return
endfunction

%APPROX PI
function piapprox = f_approx_pi (pi_methode, nbr_val)
  format long;
  count = 0;
  switch pi_methode
    case 1
      x = get_karray(nbr_val);
      cord = x_to_cord(x);
    case 2
      x = R250_GEN(nbr_val*2, 65539, 0, 2^31, 123456789);
      cord = x_to_cord (x);
    case 3
      x = R250_generator('aleatoire250.txt', nbr_val*2);
      cord = x_to_cord (x);
    case 4
      cord = rdm_cord(nbr_val);
  endswitch
  for i=1 : size(cord)
    if ( (cord(i,1)^2 + cord(i,2)^2) <=1 )
      count = count + 1;
    endif
  endfor
  piapprox = 4*(count / nbr_val);
  return
endfunction


%FUNCTION TO TRANSFORM X IN CORDINATES
function X_Y = x_to_cord(value)
  nbr_val = size(value);
  pos_x=1;
  pos_y=1;
  for i=1 : nbr_val
    if mod(i , 2) == 0
      val_x(pos_x,1) = value(i);
      pos_x++;
    else
      val_y(pos_y,1) = value(i);
      pos_y++;
    endif
  endfor
  val_x = val_x(1:nbr_val/2);
  val_y = val_y(1:nbr_val/2);
  val_x = ((val_x - min(val_x)) ./ (max(val_x) - min(val_x)));
  val_y = ((val_y - min(val_y)) ./ (max(val_y) - min(val_y)));
  X_Y = [val_x val_y];
  return
endfunction