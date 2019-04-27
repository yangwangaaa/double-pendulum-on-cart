% You are free to use, modify, copy, distribute the code.
% Please give a clap on medium, star on github, or share the article if you
% like.
%
% Created by github.com/jkoendev

function [X,U,T,H,conf] = dpc_keyboard_control()
  % Runs the simulation for double pendulum on a cart

  conf = struct;
  conf.r_1 = 1;
  conf.r_2 = 1;
  conf.m_c = 20;
  conf.m_1 = 3;
  conf.m_2 = 0.1;
  conf.g = 9.81;
  conf.xi_1 = 1e-2;;
  conf.xi_2 = 1.5e-1;

  x0 = [0; -pi; 0; 0; 0; 0];

  ts = 0.01;
  [fig, h] = dpc_draw_prepare(x0, x0, x0, conf);
  
  global U_STORAGE
  U_STORAGE = 0;
  
  global EXIT_STORAGE
  EXIT_STORAGE = false;
  
  set(fig, 'KeyPressFcn', @(src,event) keydown(event, U_STORAGE));
  set(fig, 'KeyReleaseFcn', @(src,event) keyup(event, U_STORAGE));
  
 
  x = x0;
  t = 0;
  X = x0;
  U = [];
  T = 0;
  waitforbuttonpress
  while(1)
    tic;
    u = U_STORAGE;
    x = x + ts * dpc_ode(t, x, u, conf);
    t = t + ts;
    u
    X = [X,x];
    U = [U,u];
    T = [T,t];
    dpc_draw_frame(h,t,x,u,conf);
    pause(ts-toc)
    if EXIT_STORAGE
      break;
    end
  end
  H = T(2:end)-T(1:end-1);
end

function keydown(event, u)
  global U_STORAGE
  
  if event.Key == 'h'
    U_STORAGE = -300;
  elseif event.Key == 'j'
    U_STORAGE = 300;
  elseif event.Key == 'x'
    U_STORAGE = 0;
    global EXIT_STORAGE
    EXIT_STORAGE = true;
  else
    u = 0;
  end
end

function keyup(src,event)
  global U_STORAGE
  U_STORAGE = 0;
end

function xdot = dpc_ode(t, x, u, conf)

  f = u;
  xdot = dpc_dynamics_generated(x(1), x(2), x(3), x(4), x(5), x(6), f, conf.r_1, conf.r_2, conf.m_c, conf.m_1, conf.m_2, conf.g, conf.xi_1, conf.xi_2);

end
