function anim_lines(lines, srk, amt)
    fig = figure;
    axis([-5 5 -5 5])
    hold on

    for i = 1 : amt
        plot(srk(i,1), srk(i,2), Marker=".", MarkerSize=20)
    end

    amt_sl = size(lines, 1) % amount of streamlines
    len = size(lines(1).XData, 2)
    F(len) = struct('cdata',[],'colormap',[]);
    a = arrayfun(@(x) animatedline(), 1:amt_sl)


    for k = 1 : len
        for l = 1 : amt_sl
            addpoints(a(l), lines(l).XData(1,k), lines(l).YData(1,k));
        end
        % update screen
        drawnow limitrate
        F(k) = getframe(fig);
    end

    %% Export as movie
    figure;
    v = VideoWriter('newfile.avi');
    v.Quality = 95;
    open(v)
    movie(F,1,60)
    writeVideo(v,F)
    close(v)

end