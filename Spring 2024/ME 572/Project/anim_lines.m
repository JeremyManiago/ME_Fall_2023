function anim_lines(lines, srk, vtx, exprt)
    fig = figure;
    axis([-5 5 -5 5])
    hold on

    plot([srk(:,1)], [srk(:,2)], Marker=".", MarkerSize=20, LineStyle="none")
    plot([vtx(:,1)], [vtx(:,2)], Marker=".", MarkerSize=20, LineStyle="none")

    amt_sl = size(lines, 1) % amount of streamlines
    len = size(lines(1).XData, 2)
    F(len) = struct('cdata',[],'colormap',[]);
    a = arrayfun(@(x) animatedline(), 1:amt_sl)

    j = 1;
    for k = 1 : min(size(lines(j).XData, 2), size(lines(j).YData, 2))
        for l = 1 : amt_sl
            if size(lines(l).XData, 2) >= k
                addpoints(a(l), lines(l).XData(1,k), lines(l).YData(1,k));
            end
        end
        j = j + 1;
        % update screen
        drawnow limitrate
        F(k) = getframe(fig);
    end

    if exprt == true
    %% Export as movie
    figure;
    v = VideoWriter('newfile.avi');
    v.Quality = 95;
    open(v)
    movie(F,1,60)
    writeVideo(v,F)
    close(v)
    end

end