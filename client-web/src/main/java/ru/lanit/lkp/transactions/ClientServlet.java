package ru.lanit.lkp.transactions;

import java.io.IOException;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.apache.commons.lang3.StringUtils;

import ru.lanit.lkp.Server;

/**
 * http://localhost:8080/caller/call?name=caller_error
 */
@WebServlet(urlPatterns = "/call")
public class ClientServlet extends HttpServlet {

    @EJB
    private Server client;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        if (StringUtils.isEmpty(name)) {
            name = "(empty)";
        }

        client.run(name);

        req.setAttribute("result", "DONE");
        req.getRequestDispatcher("WEB-INF/jsp/call.jsp").forward(req, resp);
    }

}
